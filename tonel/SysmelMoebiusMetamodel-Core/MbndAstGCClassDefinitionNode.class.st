Class {
	#name : #MbndAstGCClassDefinitionNode,
	#superclass : #MbndAstAbstractClassDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGCClassDefinitionNode >> accept: aVisitor [
	^ aVisitor visitGCClassDefinitionNode: self
]

{ #category : #testing }
MbndAstGCClassDefinitionNode >> isGCClassDefinitionNode [
	^ true
]
