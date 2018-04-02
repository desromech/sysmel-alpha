Class {
	#name : #SYMLValue,
	#superclass : #SYMLObject,
	#instVars : [
		'value',
		'type',
		'environment'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #comparing }
SYMLValue >> = other [
	^ self class == other class and:
	[ type == other type and: 
	[ value = other value ] ]
]

{ #category : #converting }
SYMLValue >> asFunctionActivationValueAt: aPosition [
	self type isMetaObjectType ifTrue: [ 
		^ self value
	].

	self halt
]

{ #category : #'as yet unclassified' }
SYMLValue >> coercedIntoType: targetType at: coercionPosition. [
	^ type coerceValue: self into: targetType at: coercionPosition
]

{ #category : #accessing }
SYMLValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLValue >> environment: anObject [
	environment := anObject
]

{ #category : #comparing }
SYMLValue >> hash [
	^ (self class identityHash bitXor: type identityHash) bitXor: value hash
]

{ #category : #testing }
SYMLValue >> isSysmelValue [
	^ true
]

{ #category : #accessing }
SYMLValue >> type [
	^ type
]

{ #category : #accessing }
SYMLValue >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLValue >> value [
	^ value
]

{ #category : #accessing }
SYMLValue >> value: anObject [
	value := anObject
]
