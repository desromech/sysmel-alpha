Class {
	#name : #MbndTraitMetaBuilder,
	#superclass : #MbndAbstractTypeMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndTraitMetaBuilder class >> globalBindingName [
	^ #trait
]

{ #category : #'semantic analysis' }
MbndTraitMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstTraitDeclarationNode
]

{ #category : #'semantic analysis' }
MbndTraitMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstTraitDefinitionNode
]
