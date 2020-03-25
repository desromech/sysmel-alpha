Class {
	#name : #SysmelBlockClosureArgumentASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'colonToken',
		'type',
		'name'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitBlockClosureArgument: self
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> colonToken [
	^ colonToken
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> colonToken: aSmaCCToken [
	colonToken := aSmaCCToken
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> name [
	^ name
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> name: aSysmelExpressionASTNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aSysmelExpressionASTNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> nodeVariables [
	^ #(#type #name)
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> tokenVariables [
	^ #(#colonToken)
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> type [
	^ type
]

{ #category : #generated }
SysmelBlockClosureArgumentASTNode >> type: aSysmelParenthesesExpressionASTNode [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := aSysmelParenthesesExpressionASTNode.
	self type notNil
		ifTrue: [ self type parent: self ]
]
