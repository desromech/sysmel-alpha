Class {
	#name : #MbndAstReturnStatementNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReturnStatementNode >> accept: aVisitor [
	^ aVisitor visitReturnStatementNode: self
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstReturnStatementNode >> isReturnStatementNode [
	^ true
]
