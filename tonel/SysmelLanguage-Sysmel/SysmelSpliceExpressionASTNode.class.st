Class {
	#name : #SysmelSpliceExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expression',
		'operator'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelSpliceExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitSpliceExpression: self
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> expression [
	^ expression
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> expression: aSysmelExpressionASTNode [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := aSysmelExpressionASTNode.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> operator [
	^ operator
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
SysmelSpliceExpressionASTNode >> tokenVariables [
	^ #(#operator)
]
