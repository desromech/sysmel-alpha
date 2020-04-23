Class {
	#name : #MbndTupleType,
	#superclass : #MbndSequenceableAggregateType,
	#instVars : [
		'elements',
		'instanceSize',
		'instanceAlignment',
		'elementOffsets',
		'isNonConcreteType',
		'isTypePassedByReference',
		'isMemoryReturnedType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTupleType class >> typeName [
	^ #_TupleType
]

{ #category : #'type composition' }
MbndTupleType >> , nextType [
	<compileTime>
	^ self compilationTarget tuple: elements , { nextType }
]

{ #category : #'type composition' }
MbndTupleType >> -- nextType [
	<compileTime>
	^ self compilationTarget tuple: elements , { nextType }
]

{ #category : #'type composition' }
MbndTupleType >> => returnType [
	<compileTime>
	^ self compilationTarget functionTypeWithArguments: elements returnType: returnType
]

{ #category : #visiting }
MbndTupleType >> accept: aVisitor [
	^ aVisitor visitTupleType: self
]

{ #category : #adding }
MbndTupleType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self
		addConversionRule: (MbndTupleTypeConversionRule when: [:source :target |
			source isTupleType and: [ target isTupleType and: [ source elements size = target elements size ] ]
		]);
		addConversionRule: MbndTupleToArrayTypeConversionRule new.

]

{ #category : #initialization }
MbndTupleType >> addInstanceMacros [
	super addInstanceMacros.
	self class == MbndTupleType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelector: #asValueInSetPattern do: [ :node :builder |
			MbndAstPatternMatchingSetValuePatternNode new
				position: node position;
				elements: node receiver elements;
				yourself
		];
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder tuple: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder tuple: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		]
]

{ #category : #converting }
MbndTupleType >> asImmutableValueType [
	self isPOD ifTrue: [ ^ self ].
	^ super asImmutableValueType
]

{ #category : #'semantic analysis' }
MbndTupleType >> bestConcreteTypeForLiteralValueNode: node inScope: scope [
	| concreteElements |
	self isNonConcreteType ifFalse: [ ^ self ].
	self assert: node isTupleNode.
	concreteElements := elements collectWithIndex: [ :el :index | el bestConcreteTypeForLiteralValueNode: (node elements at: index) inScope: scope ].

	^ self compilationTarget tuple: concreteElements
]

{ #category : #sizes }
MbndTupleType >> computeLayout [
	instanceSize := 0.
	instanceAlignment := 1.
	elementOffsets := elements collect: [ :el |
		| offset elementAlignment |
		
		elementAlignment := el instanceAlignment.

		instanceSize := instanceSize alignedTo: elementAlignment.
		offset := instanceSize.
		instanceSize := instanceSize + el instanceSize.
		instanceAlignment := instanceAlignment max: elementAlignment.
		offset
	].

	instanceSize := instanceSize alignedTo: instanceAlignment
]

{ #category : #accessing }
MbndTupleType >> elementOffsets [
	elementOffsets ifNil: [ self computeLayout ].
	^ elementOffsets
]

{ #category : #accessing }
MbndTupleType >> elements [
	^ elements
]

{ #category : #accessing }
MbndTupleType >> elements: anObject [
	elements := anObject
]

{ #category : #sizes }
MbndTupleType >> instanceAlignment [
	<compileTime>
	instanceAlignment ifNil: [ self computeLayout ].
	^ instanceAlignment
]

{ #category : #sizes }
MbndTupleType >> instanceSize [
	<compileTime>
	instanceSize ifNil: [ self computeLayout ].
	^ instanceSize
]

{ #category : #'testing methods' }
MbndTupleType >> isMemoryReturnedType [
	^ isMemoryReturnedType ifNil: [ isMemoryReturnedType := elements detect: [ :each | each isMemoryReturnedType ] ifFound: [ true ] ifNone: [ false ]]
]

{ #category : #testing }
MbndTupleType >> isNonConcreteType [
	^ isNonConcreteType ifNil: [
		isNonConcreteType := false.
		elements do: [ :el |
			el isNonConcreteType ifTrue: [ 
				isNonConcreteType := true.
				^ true
			 ]
		]
	]
]

{ #category : #testing }
MbndTupleType >> isTupleType [
	^ true
]

{ #category : #'testing methods' }
MbndTupleType >> isTypePassedByReference [
	^ isTypePassedByReference ifNil: [ isTypePassedByReference := elements detect: [ :each | each isTypePassedByReference ] ifFound: [ true ] ifNone: [ false ]]
]

{ #category : #printing }
MbndTupleType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	aStream nextPut: $(.
	elements doWithIndex: [ :el :index |
		index > 1 ifTrue: [ aStream nextPutAll: ' -- ' ].
		aStream nextPutAll: el asString
	].
	aStream nextPut: $).

]

{ #category : #'semantic analysis' }
MbndTupleType >> standardConcreteTypeForLiteralValueNode: node inScope: scope [
	| concreteElements |
	self isNonConcreteType ifFalse: [ ^ self ].
	concreteElements := node isTupleNode ifTrue: [ 
		elements collectWithIndex: [ :el :index | el standardConcreteTypeForLiteralValueNode: (node elements at: index) inScope: scope ]		
	] ifFalse: [
		elements collect: [ :el | el standardConcreteTypeForLiteralValueNode: node inScope: scope ]
	].

	^ self compilationTarget tuple: concreteElements
]
