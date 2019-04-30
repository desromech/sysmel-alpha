Class {
	#name : #MbndReturnType,
	#superclass : #MbndVoidType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReturnType class >> typeName [
	^ #_ReturnType
]

{ #category : #visiting }
MbndReturnType >> accept: aVisitor [
	^ aVisitor visitReturnType: self
]

{ #category : #testing }
MbndReturnType >> isReturnType [
	^ true
]
