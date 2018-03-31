Class {
	#name : #SYMLMethodMetaBuilder,
	#superclass : #SYMLStructureMetaBuilders,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #accessing }
SYMLMethodMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| methodBuilder |
	self assert: messageNode arguments isEmpty.
	
	methodBuilder := SYMLMethodBuilder new
		definitionEnvironment: anEnvironment findProgramEntityDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (methodBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)
]

{ #category : #accessing }
SYMLMethodMetaBuilder >> applyWithArguments: argumentNodes [
	<compileTime>
	<lazy>
	self halt.
	^ SYMLMethodBuilder new
		definitionEnvironment: argumentNodes environment findProgramEntityDefinitionScope;
		applyWithArguments: argumentNodes
]

{ #category : #accessing }
SYMLMethodMetaBuilder >> name [
	^ #method
]
