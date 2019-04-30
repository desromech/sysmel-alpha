Class {
	#name : #MbndArrayType,
	#superclass : #MbndAggregateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArrayType class >> typeName [
	^ #_ArrayType
]

{ #category : #visiting }
MbndArrayType >> accept: aVisitor [
	^ aVisitor visitArrayType: self
]

{ #category : #testing }
MbndArrayType >> isArrayType [
	^ true
]
