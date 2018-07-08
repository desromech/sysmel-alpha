Class {
	#name : #SYMLFieldVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'slotIndex',
		'visibility'
	],
	#category : #'Sysmel-Metamodel-Variable'
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
	type ifNil: [ 
		self error: 'Field {1} without mandatory type.' format: { self validName printString } at: aNode
	].

	self createAccessors.
	^ aNode
]

{ #category : #transforming }
SYMLFieldVariable >> createAccessors [
	<compileTime>
	name ifNil: [ ^ self ].
	
	self isPublic ifTrue: [
		self isReadOnly ifFalse: [
			self createSetter
		].

		self createGetter
	].
]

{ #category : #converting }
SYMLFieldVariable >> createGetter [
	parent addMethod: (SYMLFieldGetter new field: self) withSelector: self getterSelector
]

{ #category : #converting }
SYMLFieldVariable >> createSetter [
	parent addMethod: (SYMLFieldSetter new field: self) withSelector: self setterSelector
]

{ #category : #defaults }
SYMLFieldVariable >> defaultValue [
	^ type defaultValue
]

{ #category : #'code generation' }
SYMLFieldVariable >> getReceiverValue: receiver [
	^ (receiver slots at: slotIndex + 1) sysmelValueWithType: type inEnvironment: definitionEnvironment
]

{ #category : #accessing }
SYMLFieldVariable >> getterSelector [
	^ self name
]

{ #category : #initialization }
SYMLFieldVariable >> initialize [
	super initialize.
	self private
]

{ #category : #'code generation' }
SYMLFieldVariable >> initializeSSAVariable: ssaVariable builder: builder [
	| fieldPointer |
	fieldPointer := builder getReference: ssaVariable element: (builder constInt: slotIndex).
	builder store: (type defaultSSAValueWith: builder) in: fieldPointer
]

{ #category : #testing }
SYMLFieldVariable >> isFieldVariable [
	^ true
]

{ #category : #testing }
SYMLFieldVariable >> isPublic [
	^ self visibility == #public
]

{ #category : #accessing }
SYMLFieldVariable >> private [
	<compileTime>
	self visibility: #private
]

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> protected [
	<compileTime>
	self visibility: #protected
]

{ #category : #'as yet unclassified' }
SYMLFieldVariable >> public [
	<compileTime>
	self visibility: #public
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

{ #category : #'code generation' }
SYMLFieldVariable >> setReceiver: receiver value: value [
	receiver slots at: slotIndex + 1 put: value.
	^ value
]

{ #category : #'code generation' }
SYMLFieldVariable >> setSSAReceiver: receiverValue value: newFieldValue with: builder [
	receiverValue type isPointerType ifTrue: [ 
		builder store: newFieldValue in: (self ssaReferenceForReceiverValue: receiverValue builder: builder).
		^ newFieldValue
	].

	self halt
]

{ #category : #accessing }
SYMLFieldVariable >> setterSelector [
	^ (self name , ':') asSymbol
]

{ #category : #accessing }
SYMLFieldVariable >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
SYMLFieldVariable >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #'code generation' }
SYMLFieldVariable >> ssaReferenceForReceiverValue: receiverValue builder: builder [
	receiverValue type isPointerType ifFalse: [
		receiverValue type isVectorType ifTrue: [
			^ builder extractVector: receiverValue element: (builder constInt: slotIndex)
		].
		^ builder extractValue: receiverValue indices: {slotIndex}
	].
	^ builder getReference: receiverValue element: (builder constInt: slotIndex)
]

{ #category : #accessing }
SYMLFieldVariable >> visibility [
	^ visibility
]

{ #category : #accessing }
SYMLFieldVariable >> visibility: anObject [
	visibility := anObject
]
