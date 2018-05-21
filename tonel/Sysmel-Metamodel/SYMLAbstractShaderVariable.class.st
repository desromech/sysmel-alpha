Class {
	#name : #SYMLAbstractShaderVariable,
	#superclass : #SYMLAbstractVariable,
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #testing }
SYMLAbstractShaderVariable >> isBufferVariable [
	^ false
]

{ #category : #testing }
SYMLAbstractShaderVariable >> isUniformVariable [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderVariable >> referenceType [
	^ self type ref
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addShaderVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
