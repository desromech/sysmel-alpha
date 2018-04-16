Class {
	#name : #SYMLSendMessageMacro,
	#superclass : #SYMLMacro,
	#instVars : [
		'messageMethod'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLSendMessageMacro >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver arguments |
	receiver := (message receiver evaluateInEnvironment: anEnvironment).
	arguments := message arguments collect: [ :arg | (arg evaluateInEnvironment: anEnvironment)].
	^ receiver value sysmelPerform: message selector withArguments: arguments
]

{ #category : #accessing }
SYMLSendMessageMacro >> messageMethod [
	^ messageMethod
]

{ #category : #accessing }
SYMLSendMessageMacro >> messageMethod: anObject [
	messageMethod := anObject
]

{ #category : #'macro compilation' }
SYMLSendMessageMacro >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ (message withAnalyzedReceiverAndArgumentsInEnvironment: environment)
		metaMethod: self;
		valueType: (messageMethod ifNotNil: [messageMethod returnType] ifNil: [message receiver receiverType]);
		yourself
]
