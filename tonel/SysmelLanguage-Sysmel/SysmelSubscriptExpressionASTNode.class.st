Class {
	#name : #SysmelSubscriptExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'array',
		'subscript',
		'lbracket',
		'rbracket'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitSubscriptExpression: self
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> array [
	^ array
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> array: aSysmelExpressionASTNode [
	self array notNil
		ifTrue: [ self array parent: nil ].
	array := aSysmelExpressionASTNode.
	self array notNil
		ifTrue: [ self array parent: self ]
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> lbracket [
	^ lbracket
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> lbracket: aSmaCCToken [
	lbracket := aSmaCCToken
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> nodeVariables [
	^ #(#array #subscript)
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> rbracket [
	^ rbracket
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> rbracket: aSmaCCToken [
	rbracket := aSmaCCToken
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> subscript [
	^ subscript
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> subscript: aSysmelExpressionASTNode [
	self subscript notNil
		ifTrue: [ self subscript parent: nil ].
	subscript := aSysmelExpressionASTNode.
	self subscript notNil
		ifTrue: [ self subscript parent: self ]
]

{ #category : #generated }
SysmelSubscriptExpressionASTNode >> tokenVariables [
	^ #(#lbracket #rbracket)
]
