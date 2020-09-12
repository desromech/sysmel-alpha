Class {
	#name : #MbndPrimitiveBooleanType,
	#superclass : #MbndPrimitiveScalarType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveBooleanType class >> typeName [
	^ #_PrimitiveBooleanType
]

{ #category : #visiting }
MbndPrimitiveBooleanType >> accept: aVisitor [
	^ aVisitor visitPrimitiveBooleanType: self
]

{ #category : #initialization }
MbndPrimitiveBooleanType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	vectorOrScalarType
		addArithmetic: #'prefix-!' unaryIntrinsic: #lnot;
		addArithmetic: #not unaryIntrinsic: #lnot.
	
	vectorOrScalarType isPrimitiveVectorType ifTrue: [ 
		vectorOrScalarType
			addBuiltIn: #isAnySet intrinsicNamed: 'vector.any' argumentTypes: #() returnType: self compilationTarget booleanType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #isAllSet intrinsicNamed: 'vector.all' argumentTypes: #() returnType: self compilationTarget booleanType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			]

	].	

]

{ #category : #initialization }
MbndPrimitiveBooleanType >> addInstanceMacros [
	self class == MbndPrimitiveBooleanType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelectors: #(isAllSet isAnySet) do: [ :node :builder | node receiver ];
		onMacroSelectors: #(and: &&) do: [ :node :builder |
			(builder if: node receiver
				trueValue: (builder macroInlineBlock: node arguments first)
				falseValue: builder literalBooleanFalse)
					position: node;
					yourself
		];
		onMacroSelectors: #(or: ||) do: [ :node :builder |
			(builder if: node receiver
				trueValue: builder literalBooleanTrue
				falseValue: (builder macroInlineBlock: node arguments first))
					position: node;
					yourself
		].
]

{ #category : #converting }
MbndPrimitiveBooleanType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget booleanType
]

{ #category : #'default values' }
MbndPrimitiveBooleanType >> defaultValueAt: aPosition [
	^ MbndValue value: false type: self
]

{ #category : #initialization }
MbndPrimitiveBooleanType >> initialize [
	super initialize.
	self
		instanceSize: 1;
		instanceAlignment: 1.
]

{ #category : #testing }
MbndPrimitiveBooleanType >> isAcceptableLiteralValue: literalValue [
	^ literalValue == true or: [ literalValue == false ]
]

{ #category : #'testing methods' }
MbndPrimitiveBooleanType >> isPrimitiveBooleanType [
	^ true
]

{ #category : #testing }
MbndPrimitiveBooleanType >> literalTypeForValue: value [
	value == true ifTrue: [^ self compilationTarget literalBooleanTrueType ].
	value == false ifTrue: [^ self compilationTarget literalBooleanFalseType ].
	^ super literalTypeForValue: value
]

{ #category : #adding }
MbndPrimitiveBooleanType >> literalTypesThatCanBeConvertedToMe [
	^ {self compilationTarget literalBooleanType . self compilationTarget literalBooleanTrueType . self compilationTarget literalBooleanFalseType }
]

{ #category : #'as yet unclassified' }
MbndPrimitiveBooleanType >> oneConstantValue [
	^ MbndValue value: true type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveBooleanType >> zeroConstantValue [
	^ MbndValue value: false type: self
]
