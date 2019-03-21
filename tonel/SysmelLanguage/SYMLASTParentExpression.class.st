Class {
	#name : #SYMLASTParentExpression,
	#superclass : #SYMLASTNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelLanguage-AST'
}

{ #category : #converting }
SYMLASTParentExpression >> buildMoebiusAST: builder [
	^ expression buildMoebiusAST: builder
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

{ #category : #testing }
SYMLASTParentExpression >> isParentExpression [
	^ true
]

{ #category : #printing }
SYMLASTParentExpression >> printOn: aStream [
	aStream nextPutAll: 'parenthesis'
]
