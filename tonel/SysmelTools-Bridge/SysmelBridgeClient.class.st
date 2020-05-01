Class {
	#name : #SysmelBridgeClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'callStatesMutex',
		'nextCallSerialNumber',
		'pendingCallsDictionary',
		'sendingProcess',
		'receptionProcess',
		'sendingQueue',
		'pendingMessagesToSendSemaphore'
	],
	#category : #'SysmelTools-Bridge'
}

{ #category : #'connection open/close' }
SysmelBridgeClient class >> connectToHostNamed: hostName port: port [
	^ self new connectToHostNamed: hostName port: port
]

{ #category : #'node communication' }
SysmelBridgeClient >> call: request [
	| callState |
	callState := self newCallRequest.
	self sendMessage: { callState serial . #call . request }.
	^ callState waitResponse
]

{ #category : #'node communication' }
SysmelBridgeClient >> cast: request [
	^ self sendMessage: { nil . #cast . request }
]

{ #category : #'initialize-release' }
SysmelBridgeClient >> close [
	socket ifNil: [ ^ self ].
	pendingMessagesToSendSemaphore consumeAllSignals.
	sendingProcess ifNotNil: [sendingProcess terminate . sendingProcess := nil].
	receptionProcess ifNotNil: [receptionProcess terminate . receptionProcess := nil].
	socket close.
	socket := nil
]

{ #category : #'connection open/close' }
SysmelBridgeClient >> connectToHostNamed: hostName port: port [
	socket := Socket newTCP.
	socket connectToHostNamed: hostName port: port;
		sendData: 'PHRS'.
		
	self
		startSendingProcess;
		startReceptionProcess
	
]

{ #category : #evaluating }
SysmelBridgeClient >> convertEvalResultError: erlangError [
"	erlangError second = #exception ifTrue: [
		^ SysmelBridgeExceptionError new
			erlangError: erlangError;
			exception: erlangError third;
			yourself
	].

	erlangError second = #parse ifTrue: [
		^ ErlangEvalParseError new
			erlangError: erlangError;
			errorInfo: erlangError third;
			yourself
	].

	erlangError second = #scan ifTrue: [
		^ ErlangEvalScanError new
			erlangError: erlangError;
			errorInfo: erlangError third;
			errorLocation: erlangError fourth;
			yourself
	]."

	^ SysmelBridgeEvalError new
		sysmelError: erlangError;
		yourself
]

{ #category : #evaluating }
SysmelBridgeClient >> evalMethod: aCompiledMethod [
	^ self call: { #evalMethod . aCompiledMethod }
]

{ #category : #evaluating }
SysmelBridgeClient >> evalValue: aString [
	^ self processEvalResultValue: (self eval: aString)
]

{ #category : #evaluating }
SysmelBridgeClient >> evalValue: aString bindings: bindings [
	^ self processEvalResultValue: (self eval: aString bindings: bindings)
]

{ #category : #initialization }
SysmelBridgeClient >> initialize [
	super initialize.
	callStatesMutex := Semaphore forMutualExclusion.
	nextCallSerialNumber := 0.
	pendingCallsDictionary := WeakValueDictionary new.
	sendingQueue := WaitfreeQueue new. 
	pendingMessagesToSendSemaphore := Semaphore new.
]

{ #category : #'instance creation' }
SysmelBridgeClient >> newCallRequest [
	| callState |
	callStatesMutex critical: [ 
		callState := SysmelBridgeCallState new serial: nextCallSerialNumber.
		nextCallSerialNumber := nextCallSerialNumber + 1.		
		pendingCallsDictionary at: callState serial put: callState
	].

	^ callState

]

{ #category : #evaluating }
SysmelBridgeClient >> pharoDoIt: methodSource [
	| method |
	method := OpalCompiler new
		source: methodSource;
		noPattern: true;
		compile.
	^ self evalMethod: method encodeForSysmelBridge
]

{ #category : #private }
SysmelBridgeClient >> processCallSerial: callSerial response: callResponse [
	| callState |
	callStatesMutex critical: [ 
		callState := pendingCallsDictionary at: callSerial.
		pendingCallsDictionary removeKey: callSerial.
		callState ifNotNil: [
			callState setResponse: callResponse
		]
	]
]

{ #category : #evaluating }
SysmelBridgeClient >> processEvalResult: evalResult [
	| evalResultType |
	self assert: evalResult isArray.
	evalResultType := evalResult first.
	evalResultType == #value ifTrue: [ ^ evalResult ].
	evalResultType == #error ifTrue: [ ^ (self convertEvalResultError: evalResult) signal ].
	self error: 'Unsupported eval result.'
]

{ #category : #evaluating }
SysmelBridgeClient >> processEvalResultValue: evalResult [
	^ (self processEvalResult: evalResult) second
]

{ #category : #private }
SysmelBridgeClient >> processReceivedMessage: message [
	(message isArray and: [message size = 3 and: [message first == #response]]) ifTrue: [ 
		self processCallSerial: message second response: message third
	].

]

{ #category : #private }
SysmelBridgeClient >> receptionProcessIteration [
	| messageSize encodedMessage message messageSizeBuffer receivedSize newReceivedBytes |
	"Receive the message size"
	messageSizeBuffer := ByteArray new: 4.
	socket receiveDataInto: messageSizeBuffer.
	messageSize := messageSizeBuffer unsignedLongAt: 1 bigEndian: false.

	"Receive the message"
	encodedMessage := ByteArray new: messageSize.
	receivedSize := 0.
	[ receivedSize < messageSize ] whileTrue:  [ 
		newReceivedBytes := socket receiveDataInto: encodedMessage startingAt: 1 + receivedSize.
		receivedSize := receivedSize + newReceivedBytes
	].

	message := SLVMMessagePackDecoder decode: encodedMessage.
	self processReceivedMessage: message.
]

{ #category : #'node communication' }
SysmelBridgeClient >> sendEncodedMessage: encodedMessage [
	sendingQueue nextPut: encodedMessage.
	pendingMessagesToSendSemaphore signal
]

{ #category : #'node communication' }
SysmelBridgeClient >> sendMessage: content [
	^ self sendEncodedMessage: (SLVMMessagePackEncoder encodeObject: content asSLVMMessagePackSerializableObject)
]

{ #category : #private }
SysmelBridgeClient >> sendingProcessIteration [
	| nextMessage size |
	size := ByteArray new: 4.
	pendingMessagesToSendSemaphore consumeAllSignals.
	[nextMessage := sendingQueue nextOrNil] whileNotNil: [ 
		size unsignedLongAt: 1 put: nextMessage size bigEndian: false.
		socket sendData: size; sendData: nextMessage.
	].
  
	pendingMessagesToSendSemaphore wait
]

{ #category : #private }
SysmelBridgeClient >> startReceptionProcess [
	| session |
	session := Smalltalk session.
	receptionProcess ifNotNil: [ receptionProcess terminate ].
	receptionProcess := [ 
		[socket isNotNil and: [session == Smalltalk session]] whileTrue: [
			self receptionProcessIteration
		]
	] fork
]

{ #category : #private }
SysmelBridgeClient >> startSendingProcess [
	| session |
	session := Smalltalk session.
	sendingProcess ifNotNil: [ sendingProcess terminate ].
	sendingProcess := [
		[socket isNotNil and: [session == Smalltalk session]] whileTrue: [
			self sendingProcessIteration
		]
	] fork
]
