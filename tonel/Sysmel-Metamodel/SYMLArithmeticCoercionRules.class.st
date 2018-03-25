Class {
	#name : #SYMLArithmeticCoercionRules,
	#superclass : #SYMLTypeCoercionRules,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLArithmeticCoercionRules >> coerceIntegerType: integerType withFloatType: floatType [
	<coerce: #IntegerType with: #FloatType>
	^ floatType
]

{ #category : #'as yet unclassified' }
SYMLArithmeticCoercionRules >> coerceIntegerType: firstInteger withIntegerType: secondInteger [
	<coerce: #IntegerType with: #IntegerType>
	firstInteger == secondInteger ifTrue: [ ^ firstInteger ].
	(firstInteger size < 4 and: [ secondInteger size < 4 ]) ifTrue: [ ^ target int32Type ].
	
	self halt.
]

{ #category : #'as yet unclassified' }
SYMLArithmeticCoercionRules >> coerceLiteralIntegerType: literalIntegerType withIntegerType: integerType [
	<coerce: #LiteralIntegerType with: #IntegerType>
	integerType size < 4 ifTrue: [ ^ target int32Type ].
	^ integerType
]

{ #category : #'as yet unclassified' }
SYMLArithmeticCoercionRules >> coerceLiteralIntegerType: literalIntegerType withLiteralFloatType: literalFloatType [
	<coerce: #LiteralIntegerType with: #LiteralFloatType>
	^ literalFloatType
]
