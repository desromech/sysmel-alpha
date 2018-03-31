Class {
	#name : #SYMLFieldMetaBuilder,
	#superclass : #SYMLStructureMetaBuilders,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'as yet unclassified' }
SYMLFieldMetaBuilder class >> specialScopeName [
	^ #structure
]

{ #category : #'meta methods' }
SYMLFieldMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| localBuilder |
	self assert: messageNode arguments isEmpty.
	
	localBuilder := SYMLFieldVariableVariableBuilder new
		definitionEnvironment: anEnvironment findProgramEntityDefinitionScope;
		sourcePosition: aSourcePosition;
		name: messageNode selector;
		yourself.
	^ messageNode buildLiteralWithValue: (localBuilder sysmelValueWithType: compilationTarget compilerObjectType inEnvironment: anEnvironment)
]

{ #category : #accessing }
SYMLFieldMetaBuilder >> name [
	^ #field
]
