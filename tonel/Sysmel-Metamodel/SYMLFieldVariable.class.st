Class {
	#name : #SYMLFieldVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'slotIndex'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> bindingForReceiver: receiver symbol: symbol [
	^ SYMLReceiverFieldVariable new
		field: self;
		receiver: receiver;
		yourself
]

{ #category : #converting }
SYMLFieldVariable >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #initialization }
SYMLFieldVariable >> initializeSSAVariable: ssaVariable builder: builder [
	| fieldPointer |
	fieldPointer := builder getReference: ssaVariable element: (builder constInt: slotIndex).
	builder store: (type defaultSSAValueWith: builder) in: fieldPointer
]

{ #category : #testing }
SYMLFieldVariable >> isFieldVariable [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> referenceType [
	^ self type ref
]

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addFieldVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLFieldVariable >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
SYMLFieldVariable >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #initialization }
SYMLFieldVariable >> ssaReferenceForReceiverValue: receiverValue builder: builder [
	^ builder getReference: receiverValue element: (builder constInt: slotIndex)
]
