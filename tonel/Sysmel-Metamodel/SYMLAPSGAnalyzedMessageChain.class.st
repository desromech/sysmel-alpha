Class {
	#name : #SYMLAPSGAnalyzedMessageChain,
	#superclass : #SYMLAPSGMessageChain,
	#instVars : [
		'hasReceiverValue'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #copying }
SYMLAPSGAnalyzedMessageChain >> copyForSemanticAnalysis [
	^ self
]

{ #category : #copying }
SYMLAPSGAnalyzedMessageChain >> copyReplacingNode: oldNode with: newNode [
	| result originalReceiver newReceiver |
	result := self copy.
	self assert: result messages last receiver receiverValue == result receiver.
	
	originalReceiver := result receiver.
	newReceiver := result receiver copyReplacingNode: oldNode with: newNode.
	
	result
		receiver: newReceiver;
		messages: (result messages collect: [:message | (message copyReplacingNode: oldNode with: newNode)
				copyReplacingNode: originalReceiver with: newReceiver]).
	self assert: result messages last receiver receiverValue == result receiver.

	^ result
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> evaluateTypeInEnvironment: anEnvironment [
	^ messages last evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> generateSSACodeWith: aBuilder [
	| result |
	aBuilder withDebugPosition: self position do: [ 
		result := receiver generateSSACodeWith: aBuilder.
		messages do: [ :message |
			result := message generateSSACodeWith: aBuilder
		].
 	].
	^ result
]

{ #category : #accessing }
SYMLAPSGAnalyzedMessageChain >> hasReceiverValue [
	^ hasReceiverValue
]

{ #category : #accessing }
SYMLAPSGAnalyzedMessageChain >> hasReceiverValue: anObject [
	hasReceiverValue := anObject
]

{ #category : #initialization }
SYMLAPSGAnalyzedMessageChain >> initialize [
	super initialize.
	hasReceiverValue := false.
]

{ #category : #copying }
SYMLAPSGAnalyzedMessageChain >> postCopy [
	| newReceiver |
	hasReceiverValue ifTrue: [
		newReceiver := receiver copy chain: self; yourself.
		self assert: messages last receiver receiverValue == receiver.
		messages := messages collect: [ :message | message copyReplacingNode: receiver with: newReceiver ].
		receiver := newReceiver.
		self assert: messages last receiver receiverValue == receiver.
	] ifFalse: [ 
		super postCopy
	]
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> type [
	^ messages last type
]
