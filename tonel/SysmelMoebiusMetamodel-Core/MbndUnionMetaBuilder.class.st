Class {
	#name : #MbndUnionMetaBuilder,
	#superclass : #MbndAbstractTypeMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndUnionMetaBuilder class >> globalBindingName [
	^ #union
]

{ #category : #'semantic analysis' }
MbndUnionMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstUnionDeclarationNode
]

{ #category : #'semantic analysis' }
MbndUnionMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstUnionDefinitionNode
]
