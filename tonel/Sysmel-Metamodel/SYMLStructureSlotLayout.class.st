Class {
	#name : #SYMLStructureSlotLayout,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'fields',
		'slotIndex',
		'offset'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #accessing }
SYMLStructureSlotLayout >> concreteSSAType [
	^ type concreteSSAType
]

{ #category : #defaults }
SYMLStructureSlotLayout >> defaultValue [
	(fields size = 1 and: [ fields first isVTablePointerField ]) ifTrue: [ 
		^ fields first defaultValue
	].

	^ type defaultValue
]

{ #category : #accessing }
SYMLStructureSlotLayout >> fields [
	^ fields
]

{ #category : #accessing }
SYMLStructureSlotLayout >> fields: anObject [
	fields := anObject
]

{ #category : #accessing }
SYMLStructureSlotLayout >> name [
	^ name
]

{ #category : #accessing }
SYMLStructureSlotLayout >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLStructureSlotLayout >> offset [
	^ offset
]

{ #category : #accessing }
SYMLStructureSlotLayout >> offset: newOffset [
	offset := newOffset.
	fields do: [ :f | f offset: newOffset ]
]

{ #category : #accessing }
SYMLStructureSlotLayout >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
SYMLStructureSlotLayout >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
SYMLStructureSlotLayout >> type [
	^ type
]

{ #category : #accessing }
SYMLStructureSlotLayout >> type: anObject [
	type := anObject
]
