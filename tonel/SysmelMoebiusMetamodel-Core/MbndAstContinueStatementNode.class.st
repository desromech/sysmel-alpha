Class {
	#name : #MbndAstContinueStatementNode,
	#superclass : #MbndAstStatementNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstContinueStatementNode >> accept: aVisitor [
	^ aVisitor visitContinueStatementNode: self
]

{ #category : #testing }
MbndAstContinueStatementNode >> isContinueStatementNode [
	^ true
]
