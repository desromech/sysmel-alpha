Class {
	#name : #MbndStructureMetaBuilder,
	#superclass : #MbndAbstractTypeMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndStructureMetaBuilder class >> globalBindingName [
	^ #struct
]

{ #category : #accessing }
MbndStructureMetaBuilder >> packed [
	self addFlag: #packed
]

{ #category : #'semantic analysis' }
MbndStructureMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstStructureDeclarationNode
]

{ #category : #'semantic analysis' }
MbndStructureMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstStructureDefinitionNode
]
