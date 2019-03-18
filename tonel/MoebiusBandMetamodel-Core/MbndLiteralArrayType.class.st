Class {
	#name : #MbndLiteralArrayType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralArrayType class >> typeName [
	^ #_LiteralArray
]

{ #category : #'testing methods' }
MbndLiteralArrayType >> isLiteralArrayType [
	^ true
]
