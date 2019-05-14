Class {
	#name : #MbndClassMetaBuilder,
	#superclass : #MbndAbstractClassMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndClassMetaBuilder class >> globalBindingName [
	^ #class
]

{ #category : #'semantic analysis' }
MbndClassMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstClassDeclarationNode
]

{ #category : #'semantic analysis' }
MbndClassMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstClassDefinitionNode
]
