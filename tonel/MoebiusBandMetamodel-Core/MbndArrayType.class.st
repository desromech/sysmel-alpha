Class {
	#name : #MbndArrayType,
	#superclass : #MbndAggregateType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArrayType class >> typeName [
	^ #_ArrayType
]

{ #category : #testing }
MbndArrayType >> isArrayType [
	^ true
]
