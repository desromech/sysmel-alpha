Class {
	#name : #MbndLiteralIntegerType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralIntegerType class >> typeName [
	^ #_LiteralInteger
]

{ #category : #'testing methods' }
MbndLiteralIntegerType >> isLiteralIntegerType [
	^ true
]
