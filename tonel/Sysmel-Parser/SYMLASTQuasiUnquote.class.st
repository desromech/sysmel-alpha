Class {
	#name : #SYMLASTQuasiUnquote,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTQuasiUnquote >> buildAPSG: builder [
	^ (builder quasiUnquote: (expression buildAPSG: builder))
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
