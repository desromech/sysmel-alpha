Class {
	#name : #MbndLiteralNumberType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralNumberType class >> typeName [
	^ #_LiteralNumberType
]

{ #category : #testing }
MbndLiteralNumberType >> isLiteralNumberType [
	^ true
]
