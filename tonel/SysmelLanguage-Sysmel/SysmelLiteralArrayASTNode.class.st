Class {
	#name : #SysmelLiteralArrayASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'_LeftParenToken',
		'elements',
		'rightParenToken',
		'leftParenToken'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralArrayASTNode >> _LeftParenToken [
	^ _LeftParenToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> _LeftParenToken: aSmaCCToken [
	_LeftParenToken := aSmaCCToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralArray: self
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> elements [
	^ elements
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
SysmelLiteralArrayASTNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
SysmelLiteralArrayASTNode >> tokenVariables [
	^ #(#_LeftParenToken #rightParenToken #leftParenToken)
]
