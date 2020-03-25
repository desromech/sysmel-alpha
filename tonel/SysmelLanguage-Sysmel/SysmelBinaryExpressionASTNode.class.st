Class {
	#name : #SysmelBinaryExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'left',
		'right',
		'operation'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelBinaryExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitBinaryExpression: self
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> left [
	^ left
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> left: aSysmelExpressionASTNode [
	self left notNil
		ifTrue: [ self left parent: nil ].
	left := aSysmelExpressionASTNode.
	self left notNil
		ifTrue: [ self left parent: self ]
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> nodeVariables [
	^ #(#left #right)
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> operation [
	^ operation
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> operation: aSmaCCToken [
	operation := aSmaCCToken
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> right [
	^ right
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> right: aSysmelExpressionASTNode [
	self right notNil
		ifTrue: [ self right parent: nil ].
	right := aSysmelExpressionASTNode.
	self right notNil
		ifTrue: [ self right parent: self ]
]

{ #category : #generated }
SysmelBinaryExpressionASTNode >> tokenVariables [
	^ #(#operation)
]
