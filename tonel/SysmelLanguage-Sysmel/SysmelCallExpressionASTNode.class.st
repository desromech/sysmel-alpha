Class {
	#name : #SysmelCallExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'function',
		'arguments',
		'lparent',
		'rparent'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelCallExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitCallExpression: self
]

{ #category : #generated }
SysmelCallExpressionASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelCallExpressionASTNode >> arguments: aSysmelCallExpressionArgumentsASTNode [
	self arguments notNil
		ifTrue: [ self arguments parent: nil ].
	arguments := aSysmelCallExpressionArgumentsASTNode.
	self arguments notNil
		ifTrue: [ self arguments parent: self ]
]

{ #category : #generated }
SysmelCallExpressionASTNode >> function [
	^ function
]

{ #category : #generated }
SysmelCallExpressionASTNode >> function: aSysmelExpressionASTNode [
	self function notNil
		ifTrue: [ self function parent: nil ].
	function := aSysmelExpressionASTNode.
	self function notNil
		ifTrue: [ self function parent: self ]
]

{ #category : #generated }
SysmelCallExpressionASTNode >> lparent [
	^ lparent
]

{ #category : #generated }
SysmelCallExpressionASTNode >> lparent: aSmaCCToken [
	lparent := aSmaCCToken
]

{ #category : #generated }
SysmelCallExpressionASTNode >> nodeVariables [
	^ #(#function #arguments)
]

{ #category : #generated }
SysmelCallExpressionASTNode >> rparent [
	^ rparent
]

{ #category : #generated }
SysmelCallExpressionASTNode >> rparent: aSmaCCToken [
	rparent := aSmaCCToken
]

{ #category : #generated }
SysmelCallExpressionASTNode >> tokenVariables [
	^ #(#lparent #rparent)
]
