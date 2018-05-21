Class {
	#name : #SYMLShaderDescriptorSet,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'maxBindings'
	],
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #definition }
SYMLShaderDescriptorSet >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #accessing }
SYMLShaderDescriptorSet >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	
	"self halt"
]

{ #category : #accessing }
SYMLShaderDescriptorSet >> maxBindings [
	<compileTime>
	^ maxBindings
]

{ #category : #accessing }
SYMLShaderDescriptorSet >> maxBindings: anObject [
	<compileTime>
	maxBindings := anObject
]

{ #category : #'as yet unclassified' }
SYMLShaderDescriptorSet >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [message selector numArgs = 0]) ifTrue: [
		self name: message selector.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
