Class {
	#name : #SYMLTupleType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'types'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #comparing }
SYMLTupleType >> = other [
	^ self class == other class and:
	[ types = other types ]
]

{ #category : #accessing }
SYMLTupleType >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLTupleType >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #comparing }
SYMLTupleType >> hash [
	^ self class identityHash bitXor: types hash
]

{ #category : #accessing }
SYMLTupleType >> types [
	<compileTime>
	^ types
]

{ #category : #accessing }
SYMLTupleType >> types: anObject [
	<compileTime>
	types := anObject
]
