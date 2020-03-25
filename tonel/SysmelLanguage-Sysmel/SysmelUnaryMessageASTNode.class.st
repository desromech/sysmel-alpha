Class {
	#name : #SysmelUnaryMessageASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'selector',
		'receiver'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelUnaryMessageASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitUnaryMessage: self
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> nodeVariables [
	^ #(#receiver)
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> receiver [
	^ receiver
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> receiver: aSysmelExpressionASTNode [
	self receiver notNil
		ifTrue: [ self receiver parent: nil ].
	receiver := aSysmelExpressionASTNode.
	self receiver notNil
		ifTrue: [ self receiver parent: self ]
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> selector [
	^ selector
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> selector: aSmaCCToken [
	selector := aSmaCCToken
]

{ #category : #generated }
SysmelUnaryMessageASTNode >> tokenVariables [
	^ #(#selector)
]
