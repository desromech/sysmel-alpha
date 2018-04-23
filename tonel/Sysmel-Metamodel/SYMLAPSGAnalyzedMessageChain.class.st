Class {
	#name : #SYMLAPSGAnalyzedMessageChain,
	#superclass : #SYMLAPSGMessageChain,
	#instVars : [
		'hasReceiverValue'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> evaluateTypeInEnvironment: anEnvironment [
	^ messages last evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> generateSSACodeWith: aBuilder [
	| result |
	result := receiver generateSSACodeWith: aBuilder.
	messages do: [ :message |
		result := message generateSSACodeWith: aBuilder
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
	super postCopy.
	self flag: 'TODO: Handle the case with deeper changes.'.
	hasReceiverValue ifTrue: [ 
		messages do: [ :message | message receiver receiverValue: receiver ]
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
