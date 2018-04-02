Class {
	#name : #SYMLFunctionActivationScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'function'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLFunctionActivationScope >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionActivationScope >> function: anObject [
	function := anObject
]
