Class {
	#name : #SysmelUnquoteUnaryMessageASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'receiver',
		'selector',
		'operator'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitUnquoteUnaryMessage: self
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> nodeVariables [
	^ #(#receiver #selector)
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> operator [
	^ operator
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> receiver [
	^ receiver
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> receiver: aSysmelExpressionASTNode [
	self receiver notNil
		ifTrue: [ self receiver parent: nil ].
	receiver := aSysmelExpressionASTNode.
	self receiver notNil
		ifTrue: [ self receiver parent: self ]
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> selector [
	^ selector
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> selector: aSysmelExpressionASTNode [
	self selector notNil
		ifTrue: [ self selector parent: nil ].
	selector := aSysmelExpressionASTNode.
	self selector notNil
		ifTrue: [ self selector parent: self ]
]

{ #category : #generated }
SysmelUnquoteUnaryMessageASTNode >> tokenVariables [
	^ #(#operator)
]
