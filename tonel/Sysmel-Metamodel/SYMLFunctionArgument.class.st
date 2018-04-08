Class {
	#name : #SYMLFunctionArgument,
	#superclass : #SYMLFunctionVariable,
	#instVars : [
		'definitionNode'
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
