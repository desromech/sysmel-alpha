Class {
	#name : #SYMLASTQuasiQuote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTQuasiQuote >> buildAPSG: builder [
	^ (builder quasiQuote: (expression buildAPSG: builder))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTQuasiQuote >> children [
	^ { expression }
]

{ #category : #accessing }
SYMLASTQuasiQuote >> expression [
	^ expression
]

{ #category : #accessing }
SYMLASTQuasiQuote >> expression: anObject [
	expression := anObject
]
