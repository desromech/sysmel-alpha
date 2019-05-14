Class {
	#name : #MbndAstClassDefinitionNode,
	#superclass : #MbndAstAbstractClassDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstClassDefinitionNode >> accept: aVisitor [
	^ aVisitor visitClassDefinitionNode: self
]

{ #category : #testing }
MbndAstClassDefinitionNode >> isClassDefinitionNode [
	^ true
]
