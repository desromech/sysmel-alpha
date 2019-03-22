Class {
	#name : #MbndLiteralFloatType,
	#superclass : #MbndLiteralNumberType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralFloatType class >> typeName [
	^ #_LiteralFloat
]

{ #category : #'testing methods' }
MbndLiteralFloatType >> isLiteralFloatType [
	^ true
]
