Class {
	#name : #SysmelDictionaryExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'_LeftBraceToken',
		'elements',
		'rightBraceToken',
		'periodTokens'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> _LeftBraceToken [
	^ _LeftBraceToken
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> _LeftBraceToken: aSmaCCToken [
	_LeftBraceToken := aSmaCCToken
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitDictionaryExpression: self
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> compositeTokenVariables [
	^ #(#periodTokens)
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> elements [
	^ elements
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
SysmelDictionaryExpressionASTNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	periodTokens := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> periodTokens [
	^ periodTokens
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> periodTokens: anOrderedCollection [
	periodTokens := anOrderedCollection
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> rightBraceToken [
	^ rightBraceToken
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> rightBraceToken: aSmaCCToken [
	rightBraceToken := aSmaCCToken
]

{ #category : #generated }
SysmelDictionaryExpressionASTNode >> tokenVariables [
	^ #(#_LeftBraceToken #rightBraceToken)
]
