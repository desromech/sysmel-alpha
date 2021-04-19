Class {
	#name : #MbndAggregateFieldReferenceValue,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'aggregate',
		'slotIndex',
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> aggregate [

	^ aggregate
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> aggregate: anObject [

	aggregate := anObject
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> slotIndex [

	^ slotIndex
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> slotIndex: anObject [

	slotIndex := anObject
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> type [
	^ type
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> type: anObject [

	type := anObject
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> value [
	^ (aggregate slots at: slotIndex + 1) asMoebiusValueWithType: type
]

{ #category : #accessing }
MbndAggregateFieldReferenceValue >> value: newValue [
	aggregate slots at: slotIndex + 1 put: newValue unwrapMbndValue
]
