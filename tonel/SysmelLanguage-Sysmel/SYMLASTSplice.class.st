Class {
	#name : #SYMLASTSplice,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTSplice >> buildMoebiusAST: builder [
	^ (builder splice: (expression buildMoebiusAST: builder))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTSplice >> children [
	^ { expression }
]

{ #category : #accessing }
SYMLASTSplice >> expression [
	^ expression
]

{ #category : #accessing }
SYMLASTSplice >> expression: anObject [
	expression := anObject
]
