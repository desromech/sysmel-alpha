Class {
	#name : #MbndLiteralArrayType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralArrayType class >> typeName [
	^ #_LiteralArray
]

{ #category : #'testing methods' }
MbndLiteralArrayType >> isLiteralArrayType [
	^ true
]
