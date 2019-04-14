Class {
	#name : #MbndLiteralBooleanTrueType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanTrueType class >> typeName [
	^ #_LiteralBooleanTrue
]

{ #category : #'testing methods' }
MbndLiteralBooleanTrueType >> isLiteralBooleanTrueType [
	^ true
]
