Class {
	#name : #SYMLAPSGLiteral,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'as yet unclassified' }
SYMLAPSGLiteral >> evaluateInEnvironment: anEnvironment [
	^ value
]

{ #category : #converting }
SYMLAPSGLiteral >> evaluateTypeInEnvironment: anEnvironment [
	^ value type
]

{ #category : #'meta evaluation' }
SYMLAPSGLiteral >> generateSSACodeWith: aBuilder [
	aBuilder withDebugPosition: self position do: [
		^ value generateSSACodeWith: aBuilder
	]
]

{ #category : #testing }
SYMLAPSGLiteral >> isLiteralNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGLiteral >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #printing }
SYMLAPSGLiteral >> printOn: aStream [
	aStream print: value
]

{ #category : #'meta evaluation' }
SYMLAPSGLiteral >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGLiteral >> value [
	^ value
]

{ #category : #accessing }
SYMLAPSGLiteral >> value: anObject [
	value := anObject
]
