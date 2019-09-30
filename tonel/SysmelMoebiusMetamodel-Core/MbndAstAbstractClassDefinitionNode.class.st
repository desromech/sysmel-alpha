Class {
	#name : #MbndAstAbstractClassDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#instVars : [
		'superclass'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstAbstractClassDefinitionNode >> superTypeNode [
	^ self superclass
]

{ #category : #'as yet unclassified' }
MbndAstAbstractClassDefinitionNode >> superTypeNode: aNode [
	self superclass: aNode
]

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass [
	^ superclass
]

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass: anObject [
	superclass := anObject
]
