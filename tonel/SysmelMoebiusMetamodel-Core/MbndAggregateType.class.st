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

{ #category : #converting }
MbndAggregateType >> asReceiverType [
	^ self ref
]

{ #category : #accessing }
MbndAggregateType >> getFieldOffset: fieldName [
	^ self slotLayout getFieldOffset: fieldName
]

{ #category : #'testing methods' }
MbndAggregateType >> isAggregateType [
	^ true
]
