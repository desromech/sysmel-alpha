Class {
	#name : #MbndAstQuasiQuoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuasiQuoteNode >> accept: aVisitor [
	^ aVisitor visitQuasiQuoteNode: self
]

{ #category : #accessing }
MbndAstQuasiQuoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuasiQuoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuasiQuoteNode >> isQuasiQuoteNode [
	^ true
]
