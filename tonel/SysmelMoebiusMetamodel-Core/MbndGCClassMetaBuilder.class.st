Class {
	#name : #MbndGCClassMetaBuilder,
	#superclass : #MbndAbstractClassMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndGCClassMetaBuilder class >> globalBindingName [
	^ #gcclass
]

{ #category : #'semantic analysis' }
MbndGCClassMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstGCClassDeclarationNode
]

{ #category : #'semantic analysis' }
MbndGCClassMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstGCClassDefinitionNode
]
