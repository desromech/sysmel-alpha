Class {
	#name : #SYMLFunctionMetaBuilder,
	#superclass : #SYMLDefaultMetaBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #accessing }
SYMLFunctionMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| functionBuilder |
	self assert: messageNode arguments isEmpty.
	
	functionBuilder := SYMLFunctionBuilder new
		definitionEnvironment: anEnvironment findProgramEntityDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (functionBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)
]

{ #category : #accessing }
SYMLFunctionMetaBuilder >> applyWithArguments: argumentNodes [
	<compileTime>
	<lazy>
	^ SYMLFunctionBuilder new
		definitionEnvironment: argumentNodes environment findProgramEntityDefinitionScope;
		applyWithArguments: argumentNodes
]

{ #category : #accessing }
SYMLFunctionMetaBuilder >> name [
	^ #function
]
