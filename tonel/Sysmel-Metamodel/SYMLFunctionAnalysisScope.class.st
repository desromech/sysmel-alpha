Class {
	#name : #SYMLFunctionAnalysisScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'function'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLFunctionAnalysisScope >> addLocalVariable: aLocalVariable at: aPosition [
	super addLocalVariable: aLocalVariable at: aPosition.
	function addLocal: aLocalVariable
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> function: anObject [
	function := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionAnalysisScope >> receiverType [
	^ function receiverType
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> returnType [
	^ function returnType
]
