Class {
	#name : #SYMLASTQuote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelLanguage-AST'
}

{ #category : #converting }
SYMLASTQuote >> buildMoebiusAST: builder [
	^ (builder quote: (expression buildMoebiusAST: builder))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTQuote >> children [
	^ { expression }
]

{ #category : #accessing }
SYMLASTQuote >> expression [
	^ expression
]

{ #category : #accessing }
SYMLASTQuote >> expression: anObject [
	expression := anObject
]
