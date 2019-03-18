Class {
	#name : #MbndAstLexicalScopeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLexicalScopeNode >> accept: aVisitor [
	^ aVisitor visitLexicalScopeNode: self
]

{ #category : #accessing }
MbndAstLexicalScopeNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstLexicalScopeNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstLexicalScopeNode >> isLexicalScopeNode [
	^ true
]
