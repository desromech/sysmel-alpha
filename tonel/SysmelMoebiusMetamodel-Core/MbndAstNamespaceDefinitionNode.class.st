Class {
	#name : #MbndAstNamespaceDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'body'
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
