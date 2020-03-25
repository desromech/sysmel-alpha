Class {
	#name : #SysmelQuasiUnquoteExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expression',
		'operator'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitQuasiUnquoteExpression: self
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> expression [
	^ expression
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> expression: aSysmelExpressionASTNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aSysmelExpressionASTNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> operator [
	^ operator
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
SysmelQuasiUnquoteExpressionASTNode >> tokenVariables [
	^ #(#operator)
]
