Class {
	#name : #MbndAstAbstractClassDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#instVars : [
		'superclass'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass [
	^ superclass
]

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass: anObject [
	superclass := anObject
]
