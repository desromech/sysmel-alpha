Class {
	#name : #MbndPrimitiveIntegerType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'signed'
	],
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveIntegerType class >> typeName [
	^ #_PrimitiveIntegerType
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
MbndPrimitiveIntegerType >> legalizeLiteralValue: literalValue [
	^ literalValue asInteger
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed [
	^ signed
]

{ #category : #accessing }
MbndPrimitiveIntegerType >> signed: anObject [
	signed := anObject
]