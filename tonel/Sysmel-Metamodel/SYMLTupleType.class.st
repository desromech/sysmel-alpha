Class {
	#name : #SYMLTupleType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'types'
	],
	#category : #'Sysmel-Metamodel-Type'
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
	compilationTarget := anObject.
	definitionEnvironment := compilationTarget fakeEnvironment.
	self addTypeKindBaseTrait
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
SYMLTupleType >> typeKindBaseTrait [
	^ compilationTarget tupleTypeTrait
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
