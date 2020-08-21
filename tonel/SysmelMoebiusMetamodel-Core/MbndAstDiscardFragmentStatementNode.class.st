Class {
	#name : #MbndAstDiscardFragmentStatementNode,
	#superclass : #MbndAstStatementNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDiscardFragmentStatementNode >> accept: aVisitor [
	^ aVisitor visitDiscardFragmentStatementNode: self
]

{ #category : #testing }
MbndAstDiscardFragmentStatementNode >> isDiscardFragmentStatementNode [
	^ true
]
