Class {
	#name : #MbndPrimitiveFloatType,
	#superclass : #MbndPrimitiveNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType class >> typeName [
	^ #_PrimitiveFloatType
]

{ #category : #visiting }
MbndPrimitiveFloatType >> accept: aVisitor [
	^ aVisitor visitPrimitiveFloatType: self
]

{ #category : #initialization }
MbndPrimitiveFloatType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	super addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType.

	vectorOrScalarType
		addArithmetic: #sqrt unaryIntrinsic: #sqrt
]

{ #category : #converting }
MbndPrimitiveFloatType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget float64Type
]

{ #category : #'default values' }
MbndPrimitiveFloatType >> defaultValueAt: aPosition [
	^ MbndValue value: 0.0 type: self
]

{ #category : #testing }
MbndPrimitiveFloatType >> isAcceptableLiteralValue: literalValue [
	^ literalValue isNumber
]

{ #category : #'testing methods' }
MbndPrimitiveFloatType >> isPrimitiveFloatType [
	^ true
]

{ #category : #testing }
MbndPrimitiveFloatType >> legalizeLiteralValue: literalValue [
	^ literalValue asFloat
]

{ #category : #'semantic analysis' }
MbndPrimitiveFloatType >> literalTypeForValue: value [
	value isFloat ifTrue: [ ^ self compilationTarget literalFloatType ].
	^ super literalTypeForValue: value
]

{ #category : #adding }
MbndPrimitiveFloatType >> literalTypesThatCanBeConvertedToMe [
	^ {self compilationTarget literalCharacterType . self compilationTarget literalIntegerType . self compilationTarget literalFloatType }
]
