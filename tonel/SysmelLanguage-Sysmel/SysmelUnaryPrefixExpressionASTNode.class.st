Class {
	#name : #SysmelUnaryPrefixExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'operation',
		'operand'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitUnaryPrefixExpression: self
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> nodeVariables [
	^ #(#operand)
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> operand [
	^ operand
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> operand: aSysmelExpressionASTNode [
	self operand notNil
		ifTrue: [ self operand parent: nil ].
	operand := aSysmelExpressionASTNode.
	self operand notNil
		ifTrue: [ self operand parent: self ]
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> operation [
	^ operation
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
SysmelUnaryPrefixExpressionASTNode >> tokenVariables [
	^ #(#operation)
]
