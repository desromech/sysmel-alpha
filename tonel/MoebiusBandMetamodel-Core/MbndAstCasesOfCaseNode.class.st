Class {
	#name : #MbndAstCasesOfCaseNode,
	#superclass : #MbndAstNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfCaseNode >> accept: aVisitor [
	^ aVisitor visitCasesOfCaseNode: self
]
