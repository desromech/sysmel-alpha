Class {
	#name : #MbndAstBreakStatementNode,
	#superclass : #MbndAstStatementNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBreakStatementNode >> accept: aVisitor [
	^ aVisitor visitBreakStatementNode: self
]
