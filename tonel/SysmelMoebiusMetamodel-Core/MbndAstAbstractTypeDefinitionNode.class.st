Class {
	#name : #MbndAstAbstractTypeDefinitionNode,
	#superclass : #MbndAstAbstractProgramEntityDefinitionNode,
	#instVars : [
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body: anObject [
	body := anObject
]
