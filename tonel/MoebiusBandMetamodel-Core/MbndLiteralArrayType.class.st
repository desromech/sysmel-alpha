Class {
	#name : #MbndLiteralArrayType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralArrayType class >> typeName [
	^ #_LiteralArray
]

{ #category : #'testing methods' }
MbndLiteralArrayType >> isLiteralArrayType [
	^ true
]
