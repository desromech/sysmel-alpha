Class {
	#name : #SYMLFunctionScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'function'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #adding }
SYMLFunctionScope >> findProgramEntityDefinitionScopeFrom: startingPoint [
	^ startingPoint
]

{ #category : #accessing }
SYMLFunctionScope >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionScope >> function: anObject [
	function := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionScope >> programEntity [
	^ function
]

{ #category : #accessing }
SYMLFunctionScope >> returnType [
	^ function returnType
]
