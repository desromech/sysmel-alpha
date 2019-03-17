Class {
	#name : #MbndLiteralBooleanType,
	#superclass : #MbndLiteralValueType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndLiteralBooleanType class >> typeName [
	^ #_LiteralBoolean
]

{ #category : #'testing methods' }
MbndLiteralBooleanType >> isLiteralBooleanType [
	^ true
]
