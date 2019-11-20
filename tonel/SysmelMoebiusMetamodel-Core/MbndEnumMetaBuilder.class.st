Class {
	#name : #MbndEnumMetaBuilder,
	#superclass : #MbndAbstractTypeMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndEnumMetaBuilder class >> globalBindingName [
	^ #enum
]

{ #category : #'semantic analysis' }
MbndEnumMetaBuilder >> typeDeclarationNodeClass [
	^ MbndAstEnumDeclarationNode
]

{ #category : #'semantic analysis' }
MbndEnumMetaBuilder >> typeDefinitionNodeClass [
	^ MbndAstEnumDefinitionNode
]

{ #category : #accessing }
MbndEnumMetaBuilder >> valueType: valueType [
	self ensureTypeDefinitionNode.
	typeDefinitionNode valueType: valueType
]

{ #category : #accessing }
MbndEnumMetaBuilder >> values: values [
	self ensureTypeDefinitionNode.
	typeDefinitionNode values: values
]
