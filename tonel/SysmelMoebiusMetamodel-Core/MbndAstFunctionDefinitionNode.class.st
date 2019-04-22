Class {
	#name : #MbndAstFunctionDefinitionNode,
	#superclass : #MbndAstAbstractFunctionDefinitionNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstFunctionDefinitionNode >> accept: aVisitor [
	^ aVisitor visitFunctionDefinitionNode: self
]

{ #category : #testing }
MbndAstFunctionDefinitionNode >> isFunctionDefinitionNode [
	^ false
]
