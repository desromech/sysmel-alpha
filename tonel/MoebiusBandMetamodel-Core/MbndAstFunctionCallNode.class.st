Class {
	#name : #MbndAstFunctionCallNode,
	#superclass : #MbndAstNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFunctionCallNode >> accept: aVisitor [
	^ aVisitor visitFunctionCallNode: self
]
