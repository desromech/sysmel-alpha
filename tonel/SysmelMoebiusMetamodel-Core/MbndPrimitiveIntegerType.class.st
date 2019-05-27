Class {
	#name : #MbndPrimitiveIntegerType,
	#superclass : #MbndPrimitiveNumberType,
	#instVars : [
		'signed',
		'minValue',
		'maxValue'
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
MbndPrimitiveIntegerType >> addArithmeticIntrinsics [
	super addArithmeticIntrinsics.

	self
		addArithmetic: #bitAnd: binaryIntrinsic: #bitand;
		addArithmetic: #& binaryIntrinsic: #bitand;
		addArithmetic: #bitOr: binaryIntrinsic: #bitor;
		addArithmetic: #or binaryIntrinsic: #bitor;
		addArithmetic: #bitXor: binaryIntrinsic: #bitxor;
		addArithmetic: #'^' binaryIntrinsic: #bitxor;

		addArithmetic: #<< binaryIntrinsic: #shiftleft;
		addArithmetic: #>> binaryIntrinsic: #shiftright.

]

{ #category : #converting }
MbndPrimitiveIntegerType >> asCVariadicTypeRequiredAt: position [
	self instanceSize < 4 ifTrue: [ ^ self compilationTarget int32Type ].
	
	^ self
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
	^ literalValue asInteger
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

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed [
	^ signed
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed: anObject [
	signed := anObject
]
