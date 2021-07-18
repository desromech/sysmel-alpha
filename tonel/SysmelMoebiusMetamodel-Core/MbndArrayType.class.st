Class {
	#name : #MbndArrayType,
	#superclass : #MbndSequenceableAggregateType,
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
		onMacroSelector: #size do: [ :node :builder |
			| arrayType |
			arrayType := node receiver type withoutReferences withoutTopDecorations.
			self assert: arrayType isArrayType.
			(builder literalInteger: arrayType elements)
				position: node;
				yourself.
		];
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
		];
		onMacroSelector: #asArraySlice do: [ :node :builder |
			| arrayType |
			arrayType := node receiver type withoutReferences withoutTopDecorations.
			self assert: arrayType isArrayType.
			(builder unexpandedSend: (builder literalSymbol: #until:) to: node receiver withArguments: {
				builder literalInteger: arrayType elements
			}) position: node position
		];
		onMacroSelectors: #(until: to: from:until: from:to:) do: [ :node :builder |
			| arrayFirstElementPointer |
			arrayFirstElementPointer := builder referenceAsPointer: (
				(builder array: node receiver elementReferenceAt: (builder literalInteger: 0))
					position: node;
					yourself
			).
			builder unexpandedSend: node selector to: arrayFirstElementPointer withArguments: node arguments
		]
]

{ #category : #'semantic analysis' }
MbndArrayType >> analyzeConstructionWithArguments: argumentsTupleNode at: node with: analyzer [
	| splicedTuple arrayConstructionNode |
	splicedTuple := analyzer visitSplicingTupleNode: argumentsTupleNode.
	splicedTuple isEmpty ifTrue: [
		^ analyzer analyzeNodeIfNeeded: (self generateNewValueForNode: node with: analyzer astBuilder andWith: analyzer)
	].

	(elements isNil or: [ elements = 0 ]) ifFalse: [
		splicedTuple size ~= elements ifTrue: [ 
			^ self error: 'Parameters supplied ({1}) for constructing an array of type {2} does not match the required parameters count.' format: { splicedTuple size asString . self asString } at: node
		]
	].
	arrayConstructionNode := (analyzer astBuilder constructArrayOf: elementType withElements: splicedTuple)
		position: node;
		yourself.
	^ analyzer visitNode: arrayConstructionNode
]

{ #category : #initialization }
MbndArrayType >> asArraySliceType [
	<compileTime>
	^ elementType arraySlice
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
	<compileTime>
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

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceBasicInitialization [
	elementType ifNil: [ ^ super hasTrivialInstanceBasicInitialization ].
	^ elementType hasTrivialBasicInitialization
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceCopyAssignment [
	elementType ifNil: [ ^ super hasTrivialInstanceCopyAssignment ].
	^ elementType hasTrivialInstanceCopyAssignment
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceFinalization [
	elementType ifNil: [ ^ super hasTrivialInstanceFinalization ].
	^ elementType hasTrivialFinalization
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceInitialization [
	elementType ifNil: [ ^ super hasTrivialInstanceInitialization ].
	^ elementType hasTrivialInitialization
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceInitializationCopyingFrom [
	elementType ifNil: [ ^ super hasTrivialInstanceInitializationCopyingFrom ].
	^ elementType hasTrivialInitializationCopyingFrom
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceInitializationMovingFrom [
	elementType ifNil: [ ^ super hasTrivialInstanceInitializationMovingFrom ].
	^ elementType hasTrivialInitializationMovingFrom
]

{ #category : #testing }
MbndArrayType >> hasTrivialInstanceMoveAssignment [
	elementType ifNil: [ ^ super hasTrivialInstanceMoveAssignment ].
	^ elementType hasTrivialInstanceMoveAssignment
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

{ #category : #testing }
MbndArrayType >> isCopyable [
	elementType ifNil: [ ^ super isCopyable ].
	^ elementType isCopyable
]

{ #category : #testing }
MbndArrayType >> isMoveable [
	elementType ifNil: [ ^ super isMoveable ].
	^ elementType isMoveable
]

{ #category : #'default values' }
MbndArrayType >> makeInstance [
	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: (Array new: elements);
		yourself
]

{ #category : #printing }
MbndArrayType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
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
