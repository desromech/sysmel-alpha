Class {
	#name : #SYMLProgramEntityWithLocation,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'module',
		'definitionPosition',
		'definitionNode',
		'definitionEnvironment'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLProgramEntityWithLocation >> compilationTarget [
	^ module compilationTarget
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionEnvironment [
	^ definitionEnvironment
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionEnvironment: anObject [
	definitionEnvironment := anObject
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionNode: anObject [
	definitionNode := anObject.
	definitionNode ifNotNil: [ self definitionPosition: definitionNode position ]
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> definitionPosition: anObject [
	definitionPosition := anObject
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> module [
	^ module
]

{ #category : #accessing }
SYMLProgramEntityWithLocation >> module: anObject [
	module := anObject
]
