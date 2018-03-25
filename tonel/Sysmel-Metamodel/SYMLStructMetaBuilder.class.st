Class {
	#name : #SYMLStructMetaBuilder,
	#superclass : #SYMLDefaultMetaBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'meta methods' }
SYMLStructMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| structureType definitionEnvironment |
	messageNode arguments isNotEmpty ifTrue: [ 
		self halt.
	].
	
	structureType := self structureClass new
		parent: anEnvironment findDefinitionProgramEntity;
		module: anEnvironment module;
		name: messageNode selector;
		yourself.
	definitionEnvironment := anEnvironment findProgramEntityDefinitionScope.
	definitionEnvironment lookSymbol: structureType name ifPresent: [ :existent |
		self error: 'Duplicated structure name {1}.' format:  { structureType name } at: messageNode
	] ifAbsentPut: [ structureType ].
	
	^ messageNode buildLiteralWithValue: (structureType asSysmelValueInEnvironment: anEnvironment)
]

{ #category : #accessing }
SYMLStructMetaBuilder >> name [
	^ #struct
]

{ #category : #'meta methods' }
SYMLStructMetaBuilder >> structureClass [
	^ SYMLStructure
]
