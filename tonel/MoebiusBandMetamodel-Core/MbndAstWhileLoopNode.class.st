Class {
	#name : #MbndAstWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstWhileLoopNode >> accept: aVisitor [
	^ aVisitor visitWhileLoopNode: self
]
