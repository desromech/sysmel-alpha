Class {
	#name : #MbndSemanticError,
	#superclass : #MbndCompilationError,
	#instVars : [
		'environment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndSemanticError >> environment [
	^ environment
]

{ #category : #accessing }
MbndSemanticError >> environment: anObject [
	environment := anObject
]
