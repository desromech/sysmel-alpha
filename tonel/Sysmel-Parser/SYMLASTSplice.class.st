Class {
	#name : #SYMLASTSplice,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTSplice >> buildAPSG: builder [
	^ (builder splice: (expression buildAPSG: builder))
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
