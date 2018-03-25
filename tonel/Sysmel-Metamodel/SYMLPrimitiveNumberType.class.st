Class {
	#name : #SYMLPrimitiveNumberType,
	#superclass : #SYMLPrimitiveType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
SYMLPrimitiveNumberType >> arithmeticCoerceWith: other [
	(ArithmeticCoercionTable coerce: self with: other) ifNotNil: [ :result | ^ result ].
	^ super arithmeticCoerceWith: other
]

{ #category : #testing }
SYMLPrimitiveNumberType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #testing }
SYMLPrimitiveNumberType >> isNumberType [
	^ true
]
