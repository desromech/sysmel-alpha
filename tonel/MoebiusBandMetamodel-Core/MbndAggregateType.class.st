Class {
	#name : #MbndAggregateType,
	#superclass : #MbndNativeType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateType class >> typeName [
	^ #_AggregateType
]

{ #category : #'testing methods' }
MbndAggregateType >> isAggregateType [
	^ true
]