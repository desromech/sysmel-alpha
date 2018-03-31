Class {
	#name : #SYMLFunctionGroup,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'module',
		'name',
		'functions'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #accessing }
SYMLFunctionGroup >> findWithType: functionType ifAbsentPut: aBlock [
	| result |
	functions do: [ :function |
		function functionType = functionType ifTrue: [ ^ function ]
	].

	result := aBlock value.
	functions add: result.
	^ result
]

{ #category : #accessing }
SYMLFunctionGroup >> functions [
	^ functions
]

{ #category : #'semantic analysis' }
SYMLFunctionGroup >> generateSSACode [
	functions do: #generateSSACode
]

{ #category : #initialization }
SYMLFunctionGroup >> initialize [
	super initialize.
	functions := OrderedCollection new.
]

{ #category : #testing }
SYMLFunctionGroup >> isFunctionGroup [
	^ true
]

{ #category : #accessing }
SYMLFunctionGroup >> module [
	^ module
]

{ #category : #accessing }
SYMLFunctionGroup >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLFunctionGroup >> name [
	^ name
]

{ #category : #accessing }
SYMLFunctionGroup >> name: anObject [
	name := anObject
]

{ #category : #'semantic analysis' }
SYMLFunctionGroup >> semanticAnalysis [
	functions do: #semanticAnalysis
]
