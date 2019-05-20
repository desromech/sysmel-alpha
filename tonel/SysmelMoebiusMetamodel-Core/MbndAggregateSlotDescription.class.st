Class {
	#name : #MbndAggregateSlotDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'fields',
		'slotIndex',
		'offset'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #defaults }
MbndAggregateSlotDescription >> defaultValue [
	(fields size = 1 and: [ fields first isVTablePointerField ]) ifTrue: [ 
		^ fields first defaultValue
	].

	^ type defaultValue
]

{ #category : #accessing }
MbndAggregateSlotDescription >> fields [
	^ fields
]

{ #category : #accessing }
MbndAggregateSlotDescription >> fields: anObject [
	fields := anObject
]

{ #category : #accessing }
MbndAggregateSlotDescription >> name [
	^ name
]

{ #category : #accessing }
MbndAggregateSlotDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAggregateSlotDescription >> offset [
	^ offset
]

{ #category : #accessing }
MbndAggregateSlotDescription >> offset: newOffset [
	offset := newOffset.
	fields do: [ :f | f byteOffset: newOffset ]
]

{ #category : #accessing }
MbndAggregateSlotDescription >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
MbndAggregateSlotDescription >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
MbndAggregateSlotDescription >> type [
	^ type
]

{ #category : #accessing }
MbndAggregateSlotDescription >> type: anObject [
	type := anObject
]
