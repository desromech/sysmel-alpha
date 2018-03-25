Class {
	#name : #SYMLAPSGMessageChain,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #Sysmel-Metamodel-APSG
}

{ #category : #'as yet unclassified' }
SYMLAPSGMessageChain >> evaluateInEnvironment: anEnvironment [
	| result receiverValue |
	result := nil.
	receiverValue := anEnvironment wrapAPSGNode: receiver.
	messages do: [ :message |
		result := message evaluateInEnvironment: anEnvironment withReceiver: receiverValue
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
