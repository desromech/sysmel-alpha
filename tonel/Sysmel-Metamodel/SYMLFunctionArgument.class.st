Class {
	#name : #SYMLFunctionArgument,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'definitionNode',
		'name',
		'type'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLFunctionArgument >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
SYMLFunctionArgument >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #accessing }
SYMLFunctionArgument >> name [
	^ name
]

{ #category : #accessing }
SYMLFunctionArgument >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLFunctionArgument >> type [
	^ type
]

{ #category : #accessing }
SYMLFunctionArgument >> type: anObject [
	type := anObject
]
