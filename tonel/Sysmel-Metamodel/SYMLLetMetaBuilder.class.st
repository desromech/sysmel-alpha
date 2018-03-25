Class {
	#name : #SYMLLetMetaBuilder,
	#superclass : #SYMLDefaultMetaBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'meta methods' }
SYMLLetMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| localBuilder |
	self assert: messageNode arguments isEmpty.
	
	localBuilder := SYMLLocalVariableBuilder new
		definitionEnvironment: anEnvironment findLocalDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (localBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)
]

{ #category : #accessing }
SYMLLetMetaBuilder >> name [
	^ #let
]
