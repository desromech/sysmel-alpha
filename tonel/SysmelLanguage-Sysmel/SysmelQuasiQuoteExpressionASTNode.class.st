Class {
	#name : #SysmelQuasiQuoteExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expression',
		'operator'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitQuasiQuoteExpression: self
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> expression [
	^ expression
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> expression: aSysmelExpressionASTNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aSysmelExpressionASTNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> operator [
	^ operator
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
SysmelQuasiQuoteExpressionASTNode >> tokenVariables [
	^ #(#operator)
]
