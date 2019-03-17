Class {
	#name : #MbndLiteralFloatType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralFloatType class >> typeName [
	^ #_LiteralFloat
]

{ #category : #'testing methods' }
MbndLiteralFloatType >> isLiteralFloatType [
	^ true
]
