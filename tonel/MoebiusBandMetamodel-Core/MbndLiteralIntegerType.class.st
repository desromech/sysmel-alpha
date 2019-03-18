Class {
	#name : #MbndLiteralIntegerType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralIntegerType class >> typeName [
	^ #_LiteralInteger
]

{ #category : #'testing methods' }
MbndLiteralIntegerType >> isLiteralIntegerType [
	^ true
]
