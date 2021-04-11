Class {
	#name : #MbndSemanticError,
	#superclass : #MbndCompilationError,
	#instVars : [
		'environment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndSemanticError >> description [
	sourcePosition asActualSourcePosition isEmptySourcePosition ifTrue: [ 
		^ (environment formatPositionForErrorMessageInMacroExpansion: sourcePosition) , self messageText
	].
	^ super description
]

{ #category : #accessing }
MbndSemanticError >> environment [
	^ environment
]

{ #category : #accessing }
MbndSemanticError >> environment: anObject [
	environment := anObject
]
