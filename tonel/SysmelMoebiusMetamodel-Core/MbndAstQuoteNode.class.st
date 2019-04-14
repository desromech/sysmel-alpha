Class {
	#name : #MbndAstQuoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuoteNode >> accept: aVisitor [
	^ aVisitor visitQuoteNode: self
]

{ #category : #accessing }
MbndAstQuoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuoteNode >> isQuoteNode [
	^ true
]
