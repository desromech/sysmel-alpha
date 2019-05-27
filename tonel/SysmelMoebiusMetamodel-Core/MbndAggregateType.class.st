Class {
	#name : #MbndAggregateType,
	#superclass : #MbndNativeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateType class >> typeName [
	^ #_AggregateType
]

{ #category : #converting }
MbndAggregateType >> asImmutableValueType [
	^ self const ref
]

{ #category : #'testing methods' }
MbndAggregateType >> isAggregateType [
	^ true
]
