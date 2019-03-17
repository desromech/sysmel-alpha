Class {
	#name : #MbndAstDoWhileLoopNode,
	#superclass : #MbndAstStatementNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDoWhileLoopNode >> accept: aVisitor [
	^ aVisitor visitDoWhileLoopNode: self
]
