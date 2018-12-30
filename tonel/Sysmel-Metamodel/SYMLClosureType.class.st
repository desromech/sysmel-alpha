Class {
	#name : #SYMLClosureType,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'compilationTarget',
		'arguments',
		'returnType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #comparing }
SYMLClosureType >> = other [
	^ self class == other class and:
	[ arguments = other arguments and:
	[ returnType = other returnType ]]
]

{ #category : #accessing }
SYMLClosureType >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLClosureType >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLClosureType >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLClosureType >> compilationTarget: anObject [
	<compileTime>
	compilationTarget := anObject.
	definitionEnvironment := compilationTarget fakeEnvironment.
	self addTypeKindBaseTrait
]

{ #category : #comparing }
SYMLClosureType >> hash [
	^ self class identityHash bitXor:
	( arguments hash bitXor:
	( returnType hash ))
]

{ #category : #'as yet unclassified' }
SYMLClosureType >> isAnonymousType [
	^ true
]

{ #category : #accessing }
SYMLClosureType >> returnType [
	^ returnType
]

{ #category : #accessing }
SYMLClosureType >> returnType: anObject [
	returnType := anObject
]

{ #category : #comparing }
SYMLClosureType >> typeKindBaseTrait [
	^ self compilationTarget closureTypeTrait
]
