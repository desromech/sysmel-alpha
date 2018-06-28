Class {
	#name : #SYMLMacroMethodGenerator,
	#superclass : #SYMLAbstractMacroMethod,
	#instVars : [
		'codeGenerator'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLMacroMethodGenerator >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	^ self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
]

{ #category : #definition }
SYMLMacroMethodGenerator >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #accessing }
SYMLMacroMethodGenerator >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	codeGenerator := aDefinitionBlock value.
]

{ #category : #'macro compilation' }
SYMLMacroMethodGenerator >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	self halt.
]
