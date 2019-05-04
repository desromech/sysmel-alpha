Class {
	#name : #MbndAstNamespaceDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'body',
		'ownerProgramEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstNamespaceDefinitionNode >> accept: aVisitor [
	^ aVisitor visitNamespaceDefinitionNode: self
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> body: anObject [
	body := anObject
]

{ #category : #testing }
MbndAstNamespaceDefinitionNode >> isNamespaceDefinitionNode [
	^ true
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]
