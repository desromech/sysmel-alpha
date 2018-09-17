Class {
	#name : #SYMLArraySlotReference,
	#superclass : #SYMLAbstractValue,
	#instVars : [
		'container',
		'type',
		'slotIndex'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #converting }
SYMLArraySlotReference >> asIncompleteValue [
	^ self
]

{ #category : #converting }
SYMLArraySlotReference >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type ref inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLArraySlotReference >> container [
	^ container
]

{ #category : #accessing }
SYMLArraySlotReference >> container: anObject [
	container := anObject
]

{ #category : #accessing }
SYMLArraySlotReference >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
SYMLArraySlotReference >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
SYMLArraySlotReference >> type [
	^ type
]

{ #category : #accessing }
SYMLArraySlotReference >> type: anObject [
	type := anObject
]
