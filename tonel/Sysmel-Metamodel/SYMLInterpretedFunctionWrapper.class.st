Class {
	#name : #SYMLInterpretedFunctionWrapper,
	#superclass : #SYMLCompileTimeFunction,
	#instVars : [
		'function'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLInterpretedFunctionWrapper >> function [
	^ function
]

{ #category : #accessing }
SYMLInterpretedFunctionWrapper >> function: anObject [
	function := anObject
]
