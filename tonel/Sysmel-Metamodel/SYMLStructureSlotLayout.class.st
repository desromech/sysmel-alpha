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
SYMLStructureSlotLayout >> offset: anObject [
	offset := anObject
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
