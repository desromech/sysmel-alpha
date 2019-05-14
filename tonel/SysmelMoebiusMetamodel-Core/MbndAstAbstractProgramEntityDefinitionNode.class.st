Class {
	#name : #MbndAstAbstractProgramEntityDefinitionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'declaration'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractProgramEntityDefinitionNode >> declaration [
	^ declaration
]

{ #category : #accessing }
MbndAstAbstractProgramEntityDefinitionNode >> declaration: anObject [
	declaration := anObject
]
