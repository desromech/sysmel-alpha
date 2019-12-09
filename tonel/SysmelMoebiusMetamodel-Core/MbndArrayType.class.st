Class {
	#name : #MbndArrayType,
	#superclass : #MbndAggregateType,
	#instVars : [
		'elementType',
		'elements',
		'instanceSize'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArrayType class >> typeName [
	^ #_ArrayType
]

{ #category : #visiting }
MbndArrayType >> accept: aVisitor [
	^ aVisitor visitArrayType: self
]

{ #category : #initialization }
MbndArrayType >> addInstanceMacros [
	self class == MbndArrayType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder array: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder array: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		]
]

{ #category : #converting }
MbndArrayType >> asFieldTypeFor: owner [
	(owner isGCClassType and: [ elements = 0 ]) ifTrue: [
		^ self compilationTarget gcClassVariableDataArrayOf: elementType
	].
	^ self
]

{ #category : #testing }
MbndArrayType >> canValueBeCreatedForNode: node [
	^ node isTupleNode
]

{ #category : #testing }
MbndArrayType >> createValueForNode: node withAnalyzer: analyzer [
	self assert: node isTupleNode.
	elements > 0 ifTrue: [ 
		node elements size = elements ifFalse: [
			analyzer error: 'Cannot create array with {1} elements from a tuple with {2} elements.'
				format: { elements asString . node elements size asString } at: node
		].
	].
	^ analyzer astBuilder constructArrayOf: elementType withElements: node elements
]

{ #category : #'default values' }
MbndArrayType >> defaultValueAt: aPosition [
	| valueSlots defaultElementValue |
	
	defaultElementValue := nil.
	valueSlots := elementType == self compilationTarget uint8Type ifTrue: [ 
		ByteArray new: elements
	] ifFalse: [ 
		(1 to: elements) collect: [ :i |
			defaultElementValue ifNil: [
				defaultElementValue := (elementType defaultValueAt: aPosition) unwrapMbndValue
			]
		].
	].

	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: valueSlots;
		yourself
]

{ #category : #accessing }
MbndArrayType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndArrayType >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndArrayType >> elements [
	^ elements
]

{ #category : #accessing }
MbndArrayType >> elements: anObject [
	elements := anObject
]

{ #category : #sizes }
MbndArrayType >> instanceAlignment [
	<compileTime>
	^ elementType instanceAlignment
]

{ #category : #sizes }
MbndArrayType >> instanceSize [
	<compileTime>
	instanceSize ifNil: [ 
		instanceSize := elements = 0
			ifTrue: [0]
			ifFalse: [ elementType alignedInstanceSize * elements]
	].

	^ instanceSize
]

{ #category : #testing }
MbndArrayType >> isArrayType [
	^ true
]

{ #category : #printing }
MbndArrayType >> printOn: aStream [
	elements = 0 ifTrue: [ 
		elementType printOn: aStream.
		aStream nextPutAll: ' array'.
	] ifFalse: [ 
	].

	aStream nextPut: $(.
	elementType printOn: aStream.
	aStream nextPutAll: ' array: '.
	elements printOn: aStream.
	aStream nextPut: $).

]
