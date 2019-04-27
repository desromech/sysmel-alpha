Class {
	#name : #MbndReturnType,
	#superclass : #MbndVoidType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReturnType class >> typeName [
	^ #_ReturnType
]

{ #category : #testing }
MbndReturnType >> isReturnType [
	^ true
]