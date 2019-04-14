Class {
	#name : #MbndAggregateType,
	#superclass : #MbndNativeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateType class >> typeName [
	^ #_AggregateType
]

{ #category : #'testing methods' }
MbndAggregateType >> isAggregateType [
	^ true
]
