Class {
	#name : #SYMLAPSGMessageChain,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #copying }
SYMLAPSGMessageChain >> copyForSemanticAnalysis [
	^ self shallowCopy
		receiver: receiver copyForSemanticAnalysis;
		messages: (messages collect: #copyForSemanticAnalysis);
		yourself.
]

{ #category : #accessing }
SYMLAPSGMessageChain >> copyReplacingNode: oldNode with: newNode [
	self == oldNode ifTrue: [ ^ newNode ].
	^ self shallowCopy
		receiver: (receiver copyReplacingNode: oldNode with: newNode);
		messages: (messages collect: [:message | message copyReplacingNode: oldNode with: newNode]);
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChain >> evaluateInEnvironment: anEnvironment [
	| result |
	result := nil.
	receiver ifNotNil: [ receiver evaluateInEnvironment: anEnvironment ].
	
	messages do: [ :message |
		result := message evaluateInEnvironment: anEnvironment
	].

	^ result
]

{ #category : #'as yet unclassified' }
SYMLAPSGMessageChain >> inspectorChildren [
	^ { receiver . #messages -> messages }
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChain >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		receiver: (receiver ifNotNil: [receiver macroExpansionInEnvironment: anEnvironment]);
		messages: (messages ifNotNil: [messages collect: [:message | message macroExpansionInEnvironment: anEnvironment]]);
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChain >> macroSemanticAnalysisInEnvironment: anEnvironment [
	^ self shallowCopy
		receiver: (receiver ifNotNil: [receiver macroSemanticAnalysisInEnvironment: anEnvironment]);
		messages: (messages ifNotNil: [messages collect: [:message | message macroSemanticAnalysisInEnvironment: anEnvironment]]);
		yourself
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
	result := SYMLAPSGAnalyzedMessageChain new position: self position.
	result receiver: (receiver semanticAnalysisInEnvironment: anEnvironment).

	result receiver isMetaObjectInstance ifTrue: [ 
		myReceiverReference := result receiver.
	] ifFalse: [
		result receiver: (SYMLAPSGMessageChainReceiverValue new
			chain: self;
			position: receiver position;
			receiver: result receiver;
			yourself).
		result hasReceiverValue: true.
		myReceiverReference := SYMLAPSGMessageChainReceiverReference new
			chain: self;
			position: receiver position;
			receiverValue: result receiver;
			yourself.
	].
	
	result messages: (messages collect: [ :message |
		(message copy receiver: (message receiver ifNil: [myReceiverReference])) semanticAnalysisInEnvironment: anEnvironment
	]).

	^ result
]
