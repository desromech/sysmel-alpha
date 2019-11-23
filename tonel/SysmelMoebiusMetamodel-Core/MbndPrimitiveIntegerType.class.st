Class {
	#name : #MbndPrimitiveIntegerType,
	#superclass : #MbndPrimitiveNumberType,
	#instVars : [
		'signed',
		'minValue',
		'maxValue',
		'signBit',
		'bitMask'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveIntegerType class >> typeName [
	^ #_PrimitiveIntegerType
]

{ #category : #visiting }
MbndPrimitiveIntegerType >> accept: aVisitor [
	^ aVisitor visitPrimitiveIntegerType: self
]

{ #category : #initialization }
MbndPrimitiveIntegerType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	super addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType.

	vectorOrScalarType
		addArithmetic: #bitAnd: binaryIntrinsic: #bitand;
		addArithmetic: #& binaryIntrinsic: #bitand;
		addArithmetic: #bitOr: binaryIntrinsic: #bitor;
		addArithmetic: #| binaryIntrinsic: #bitor;
		addArithmetic: #bitXor: binaryIntrinsic: #bitxor;
		addArithmetic: #'^' binaryIntrinsic: #bitxor;

		addArithmetic: #<< binaryIntrinsic: #shiftleft;
		addArithmetic: #>> binaryIntrinsic: #shiftright;
		
		addArithmetic: #bitInvert unaryIntrinsic: #not;
		addArithmetic: #'prefix-~' unaryIntrinsic: #not;

		addArithmetic: #lowBit unaryIntrinsic: #lowBit;
		addArithmetic: #highBit unaryIntrinsic: #highBit.

		

]

{ #category : #converting }
MbndPrimitiveIntegerType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType |
	undecoratedTargetType := targetType withoutTopDecorations.
	
	undecoratedTargetType isPointerType ifTrue: [
		^ analyzer visitNode: (MbndAstIntegerToPointerCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	(undecoratedTargetType isPrimitiveIntegerType and: [ undecoratedTargetType instanceSize = self instanceSize ]) ifTrue: [
		^ analyzer visitNode: (MbndAstBitCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #converting }
MbndPrimitiveIntegerType >> asCVariadicTypeRequiredAt: position [
	self instanceSize < 4 ifTrue: [ ^ self compilationTarget int32Type ].
	
	^ self
]

{ #category : #converting }
MbndPrimitiveIntegerType >> asSignedType [
	self isSigned  ifTrue: [ ^ self ].
	^ self compilationTarget getBasicTypeNamed: name allButFirst asSymbol
]

{ #category : #converting }
MbndPrimitiveIntegerType >> asUnsignedType [
	self isUnsigned ifTrue: [ ^ self ].
	^ self compilationTarget getBasicTypeNamed: ('U' , name) asSymbol
]

{ #category : #testing }
MbndPrimitiveIntegerType >> bitMask [
	^ bitMask ifNil: [ bitMask := (1 << (instanceSize * 8))  - 1 ]
]

{ #category : #'default values' }
MbndPrimitiveIntegerType >> defaultValueAt: aPosition [
	^ MbndValue value: 0 type: self
]

{ #category : #testing }
MbndPrimitiveIntegerType >> isAcceptableLiteralValue: literalValue [
	^ literalValue isInteger
]

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isPrimitiveIntegerType [
	^ true
]

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isSigned [
	^ signed
]

{ #category : #'testing methods' }
MbndPrimitiveIntegerType >> isUnsigned [
	^ signed not
]

{ #category : #testing }
MbndPrimitiveIntegerType >> isValueInRange: value [
	^ self minValue <= value and: [ value <= self maxValue ]
]

{ #category : #testing }
MbndPrimitiveIntegerType >> legalizeLiteralValue: literalValue [
	| rawInteger |
	rawInteger := literalValue asInteger.
	^ signed
		ifTrue: [ (rawInteger bitAnd: self maxValue) -
				((rawInteger anyMask: self signBit) ifTrue: [ signBit ] ifFalse: [ 0 ])]
		ifFalse: [ rawInteger bitAnd: self bitMask ].
]

{ #category : #'semantic analysis' }
MbndPrimitiveIntegerType >> literalTypeForValue: value [
	value isInteger ifTrue: [ ^ self compilationTarget literalIntegerType ].
	^ super literalTypeForValue: value
]

{ #category : #adding }
MbndPrimitiveIntegerType >> literalTypesThatCanBeConvertedToMe [
	^ {self compilationTarget literalCharacterType . self compilationTarget literalIntegerType }
]

{ #category : #testing }
MbndPrimitiveIntegerType >> maxValue [
	maxValue ifNil: [
		signed ifTrue: [
			maxValue := (1 << (instanceSize * 8 - 1)) - 1
		] ifFalse: [ 
			maxValue := (1 << (instanceSize * 8)) - 1
		]
	].

	^ maxValue
]

{ #category : #testing }
MbndPrimitiveIntegerType >> minValue [
	minValue ifNil: [
		signed ifTrue: [
			minValue := (1 << (instanceSize * 8 - 1)) negated
		] ifFalse: [ 
			minValue := 0
		]
	].

	^ minValue
]

{ #category : #'as yet unclassified' }
MbndPrimitiveIntegerType >> oneConstantValue [
	^ MbndValue value: 1 type: self
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signBit [
	self assert: signed.
	^ signBit ifNil: [ signBit := 1 << (instanceSize *8 - 1) ].
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed [
	^ signed
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed: anObject [
	signed := anObject
]

{ #category : #'as yet unclassified' }
MbndPrimitiveIntegerType >> zeroConstantValue [
	^ MbndValue value: 0 type: self
]
