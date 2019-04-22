Class {
	#name : #MbndAstArgumentDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArgumentDefinitionNode >> accept: aVisitor [
	^ aVisitor visitArgumentDefinitionNode: self
]

{ #category : #visiting }
MbndAstArgumentDefinitionNode >> isArgumentDefinitionNode [
	^ true
]
