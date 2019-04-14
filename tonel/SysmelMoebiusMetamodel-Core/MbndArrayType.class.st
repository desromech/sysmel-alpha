Class {
	#name : #MbndArrayType,
	#superclass : #MbndAggregateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArrayType class >> typeName [
	^ #_ArrayType
]

{ #category : #testing }
MbndArrayType >> isArrayType [
	^ true
]
