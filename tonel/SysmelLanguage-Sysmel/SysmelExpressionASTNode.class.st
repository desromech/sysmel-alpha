Class {
	#name : #SysmelExpressionASTNode,
	#superclass : #SysmelAbstractASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitExpression: self
]
