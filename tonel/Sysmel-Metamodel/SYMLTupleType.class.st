Class {
	#name : #SYMLTupleType,
	#superclass : #SYMLType,
	#instVars : [
		'types'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #comparing }
SYMLTupleType >> = other [
	^ self class == other class and:
	[ types = other types ]
]

{ #category : #comparing }
SYMLTupleType >> hash [
	^ self class identityHash bitXor: types hash
]

{ #category : #testing }
SYMLTupleType >> isTupleType [
	^ true
]

{ #category : #accessing }
SYMLTupleType >> types [
	^ types
]

{ #category : #accessing }
SYMLTupleType >> types: anObject [
	types := anObject
]
