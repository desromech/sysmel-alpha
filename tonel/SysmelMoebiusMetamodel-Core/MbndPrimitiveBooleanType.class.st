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
		addArithmetic: #not unaryIntrinsic: #lnot
]

{ #category : #initialization }
MbndPrimitiveBooleanType >> addComparisonIntrinsics [
	super addComparisonIntrinsics.
	self
		addComparison: #< intrinsic: #lt;
		addComparison: #<= intrinsic: #le;
		addComparison: #>= intrinsic: #ge;
		addComparison: #> intrinsic: #gt
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
		instanceAlignment: 1;
		onMacroSelectors: #(and: &&) do: [ :node :builder |
			(builder if: node receiver trueValue: node arguments first falseValue: builder literalBooleanFalse)
				position: node;
				yourself
		];
		onMacroSelectors: #(or: ||) do: [ :node :builder |
			(builder if: node receiver trueValue: builder literalBooleanTrue falseValue: node arguments first)
				position: node;
				yourself
		].
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
