Class {
	#name : #SysmelQuoteExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expression',
		'operator'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelQuoteExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitQuoteExpression: self
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> expression [
	^ expression
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> expression: aSysmelExpressionASTNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aSysmelExpressionASTNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> operator [
	^ operator
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
SysmelQuoteExpressionASTNode >> tokenVariables [
	^ #(#operator)
]
