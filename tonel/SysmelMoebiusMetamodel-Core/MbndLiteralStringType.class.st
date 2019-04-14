Class {
	#name : #MbndLiteralStringType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralStringType class >> typeName [
	^ #_LiteralString
]

{ #category : #'testing methods' }
MbndLiteralStringType >> isLiteralStringType [
	^ true
]
