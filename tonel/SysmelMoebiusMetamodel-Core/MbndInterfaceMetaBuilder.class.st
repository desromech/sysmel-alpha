Class {
	#name : #MbndInterfaceMetaBuilder,
	#superclass : #MbndAbstractClassMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndInterfaceMetaBuilder class >> globalBindingName [
	^ #interface
]

{ #category : #'semantic analysis' }
MbndInterfaceMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstInterfaceDeclarationNode
]

{ #category : #'semantic analysis' }
MbndInterfaceMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstInterfaceDefinitionNode
]
