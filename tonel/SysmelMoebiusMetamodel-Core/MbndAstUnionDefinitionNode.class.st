Class {
	#name : #MbndAstUnionDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstUnionDefinitionNode >> accept: aVisitor [
	^ aVisitor visitUnionDefinitionNode: self
]

{ #category : #testing }
MbndAstUnionDefinitionNode >> isUnionDefinitionNode [
	^ true
]
