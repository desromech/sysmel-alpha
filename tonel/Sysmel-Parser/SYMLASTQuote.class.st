Class {
	#name : #SYMLASTQuote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTQuote >> buildAPSG: builder [
	^ (builder quote: (expression buildAPSG: builder))
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
