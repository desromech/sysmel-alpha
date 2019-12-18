Class {
	#name : #MbndLiteralByteArrayType,
	#superclass : #MbndLiteralArrayType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralByteArrayType class >> typeName [
	^ #_LiteralByteArray
]

{ #category : #'testing methods' }
MbndLiteralByteArrayType >> isLiteralByteArrayType [
	^ true
]
