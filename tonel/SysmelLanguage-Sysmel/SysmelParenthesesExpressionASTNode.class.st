Class {
	#name : #SysmelParenthesesExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expression',
		'lparent',
		'rparent'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitParenthesesExpression: self
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> expression [
	^ expression
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> expression: aSysmelExpressionASTNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aSysmelExpressionASTNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> lparent [
	^ lparent
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> lparent: aSmaCCToken [
	lparent := aSmaCCToken
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> rparent [
	^ rparent
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> rparent: aSmaCCToken [
	rparent := aSmaCCToken
]

{ #category : #generated }
SysmelParenthesesExpressionASTNode >> tokenVariables [
	^ #(#lparent #rparent)
]
