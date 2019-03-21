Class {
	#name : #SYMLASTQuasiUnquote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelLanguage-AST'
}

{ #category : #converting }
SYMLASTQuasiUnquote >> buildMoebiusAST: builder [
	^ (builder quasiUnquote: (expression buildMoebiusAST: builder))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTQuasiUnquote >> children [
	^ { expression }
]

{ #category : #accessing }
SYMLASTQuasiUnquote >> expression [
	^ expression
]

{ #category : #accessing }
SYMLASTQuasiUnquote >> expression: anObject [
	expression := anObject
]
