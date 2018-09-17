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

{ #category : #'as yet unclassified' }
SYMLArraySlotReference >> sysmelPerform: selector withArguments: arguments [
	^ self value sysmelPerform: selector withArguments: arguments
]

{ #category : #initialization }
SYMLArraySlotReference >> sysmelSetReferencedValue: aValue [
	^ self value: aValue unwrapSysmelValue
]

{ #category : #accessing }
SYMLArraySlotReference >> type [
	^ type
]

{ #category : #accessing }
SYMLArraySlotReference >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
SYMLArraySlotReference >> value [
	^ (container at: slotIndex) sysmelValueWithType: type inEnvironment: type definitionEnvironment
]

{ #category : #accessing }
SYMLArraySlotReference >> value: aNewValue [
	^ container at: slotIndex put: aNewValue
]
