Class {
	#name : #SYMLASTQuasiQuote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTQuasiQuote >> buildMoebiusAST: builder [
	^ (builder quasiQuote: (expression buildMoebiusAST: builder))
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
