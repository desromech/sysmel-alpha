Class {
	#name : #SYMLAPSGMessageChain,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGMessageChain >> evaluateInEnvironment: anEnvironment [
	| result |
	result := nil.
	messages do: [ :message |
		result := message evaluateInEnvironment: anEnvironment
	].

	^ result
]

{ #category : #'as yet unclassified' }
SYMLAPSGMessageChain >> inspectorChildren [
	^ { receiver . #messages -> messages }
]

{ #category : #accessing }
SYMLAPSGMessageChain >> messages [
	^ messages
]

{ #category : #accessing }
SYMLAPSGMessageChain >> messages: anObject [
	messages := anObject
]

{ #category : #copying }
SYMLAPSGMessageChain >> postCopy [
	receiver := receiver copy.
	messages := messages collect: #copy.
	
]

{ #category : #printing }
SYMLAPSGMessageChain >> printOn: aStream [
	aStream nextPutAll: 'chain'
]

{ #category : #accessing }
SYMLAPSGMessageChain >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLAPSGMessageChain >> receiver: anObject [
	receiver := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChain >> semanticAnalysisInEnvironment: anEnvironment [
	| result myReceiverReference |
	result := self copy.
	result receiver: (receiver semanticAnalysisInEnvironment: anEnvironment).

	result receiver isMetaObjectInstance ifTrue: [ 
		myReceiverReference := result receiver.
	] ifFalse: [ 
		myReceiverReference := SYMLAPSGMessageChainReceiverReference new
			chain: self;
			position: receiver position;
			yourself.
	].
	
	result messages: (messages collect: [ :message |
		(message copy receiver: myReceiverReference) semanticAnalysisInEnvironment: anEnvironment
	]).

	^ result
]
