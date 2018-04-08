Class {
	#name : #SYMLASTParentExpression,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTParentExpression >> buildAPSG: builder [
	^ expression buildAPSG: builder
]

{ #category : #accessing }
SYMLASTParentExpression >> children [
	^ { expression }
]

{ #category : #accessing }
SYMLASTParentExpression >> expression [
	^ expression
]

{ #category : #accessing }
SYMLASTParentExpression >> expression: anObject [
	expression := anObject
]

{ #category : #printing }
SYMLASTParentExpression >> printOn: aStream [
	aStream nextPutAll: 'parenthesis'
]
