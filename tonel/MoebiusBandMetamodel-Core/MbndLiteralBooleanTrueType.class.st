Class {
	#name : #MbndLiteralBooleanTrueType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanTrueType class >> typeName [
	^ #_LiteralBooleanTrue
]

{ #category : #'testing methods' }
MbndLiteralBooleanTrueType >> isLiteralBooleanTrueType [
	^ true
]
