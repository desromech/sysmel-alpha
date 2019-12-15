Class {
	#name : #MbndAstGlobalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'constructionPriority'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGlobalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitGlobalVariableDefinitionNode: self
]

{ #category : #accessing }
MbndAstGlobalVariableDefinitionNode >> constructionPriority [
	^ constructionPriority
]

{ #category : #accessing }
MbndAstGlobalVariableDefinitionNode >> constructionPriority: anObject [
	constructionPriority := anObject
]

{ #category : #testing }
MbndAstGlobalVariableDefinitionNode >> isGlobalVariableDefinitionNode [
	^ true
]
