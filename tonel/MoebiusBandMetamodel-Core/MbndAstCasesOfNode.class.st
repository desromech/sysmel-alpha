Class {
	#name : #MbndAstCasesOfNode,
	#superclass : #MbndAstNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfNode >> accept: aVisitor [
	^ aVisitor visitCasesOfNode: self
]
