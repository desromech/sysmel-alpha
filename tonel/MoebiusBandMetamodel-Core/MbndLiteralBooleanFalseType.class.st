Class {
	#name : #MbndLiteralBooleanFalseType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanFalseType class >> typeName [
	^ #_LiteralBooleanFalse
]

{ #category : #'testing methods' }
MbndLiteralBooleanFalseType >> isLiteralBooleanFalseType [
	^ true
]
