Class {
	#name : #MbndUnionType,
	#superclass : #MbndAggregateType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUnionType class >> typeName [
	^ #_UnionType
]

{ #category : #'testing methods' }
MbndUnionType >> isUnionType [
	^ true
]
