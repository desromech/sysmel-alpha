Class {
	#name : #MbndLiteralBooleanFalseType,
	#superclass : #MbndLiteralBooleanType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanFalseType class >> typeName [
	^ #_LiteralBooleanFalse
]

{ #category : #'testing methods' }
MbndLiteralBooleanFalseType >> isLiteralBooleanFalseType [
	^ true
]
