Class {
	#name : #SYMLReceiverFieldReference,
	#superclass : #SYMLAbstractValue,
	#instVars : [
		'container',
		'type',
		'field'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #converting }
SYMLReceiverFieldReference >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLReceiverFieldReference >> container [
	^ container
]

{ #category : #accessing }
SYMLReceiverFieldReference >> container: anObject [
	container := anObject
]

{ #category : #accessing }
SYMLReceiverFieldReference >> field [
	^ field
]

{ #category : #accessing }
SYMLReceiverFieldReference >> field: anObject [
	field := anObject
]

{ #category : #accessing }
SYMLReceiverFieldReference >> type [
	^ type
]

{ #category : #accessing }
SYMLReceiverFieldReference >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
SYMLReceiverFieldReference >> value [
	^ field getReceiverValue: container
]

{ #category : #evaluating }
SYMLReceiverFieldReference >> value: aNewValue [
	^ field setReceiver: container value: aNewValue
]