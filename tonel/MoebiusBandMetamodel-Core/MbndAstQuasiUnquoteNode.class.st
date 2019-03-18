Class {
	#name : #MbndAstQuasiUnquoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuasiUnquoteNode >> accept: aVisitor [
	^ aVisitor visitQuasiUnquoteNode: self
]

{ #category : #accessing }
MbndAstQuasiUnquoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuasiUnquoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuasiUnquoteNode >> isQuasiUnquoteNode [
	^ true
]
