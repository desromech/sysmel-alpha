Class {
	#name : #SYMLMacroExpansionRule,
	#superclass : #SYMLMacroMethod,
	#instVars : [
		'expansionTemplate'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #definition }
SYMLMacroExpansionRule >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #definition }
SYMLMacroExpansionRule >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	aDefinitionBlock type isAPSGNodeType ifFalse: [ 
		self error: 'Expected an APSG node for the macro expansion.' at: aDefinitionBlock node
	].

	expansionTemplate := aDefinitionBlock value.
	self assert: expansionTemplate isSYMLAPSGNode
]

{ #category : #'macro compilation' }
SYMLMacroExpansionRule >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| activationEnvironment expansion |
	activationEnvironment := self createActivationEnvironmentForMessage: message inEnvironment: environment at: aPosition.
	expansion :=expansionTemplate macroExpansionInEnvironment: activationEnvironment.
	^ (self sanitizeExpansion: expansion at: aPosition)
		semanticAnalysisInEnvironment: environment
]
