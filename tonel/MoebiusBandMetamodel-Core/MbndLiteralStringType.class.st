Class {
	#name : #MbndLiteralStringType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralStringType class >> typeName [
	^ #_LiteralString
]

{ #category : #'testing methods' }
MbndLiteralStringType >> isLiteralStringType [
	^ true
]
