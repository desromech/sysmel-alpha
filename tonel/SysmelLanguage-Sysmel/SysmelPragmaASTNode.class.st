Class {
	#name : #SysmelPragmaASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'message',
		'lessThan',
		'greaterThan'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelPragmaASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitPragma: self
]

{ #category : #generated }
SysmelPragmaASTNode >> greaterThan [
	^ greaterThan
]

{ #category : #generated }
SysmelPragmaASTNode >> greaterThan: aSmaCCToken [
	greaterThan := aSmaCCToken
]

{ #category : #generated }
SysmelPragmaASTNode >> lessThan [
	^ lessThan
]

{ #category : #generated }
SysmelPragmaASTNode >> lessThan: aSmaCCToken [
	lessThan := aSmaCCToken
]

{ #category : #generated }
SysmelPragmaASTNode >> message [
	^ message
]

{ #category : #generated }
SysmelPragmaASTNode >> message: aSysmelExpressionASTNode [
	self message notNil
		ifTrue: [ self message parent: nil ].
	message := aSysmelExpressionASTNode.
	self message notNil
		ifTrue: [ self message parent: self ]
]

{ #category : #generated }
SysmelPragmaASTNode >> nodeVariables [
	^ #(#message)
]

{ #category : #generated }
SysmelPragmaASTNode >> tokenVariables [
	^ #(#lessThan #greaterThan)
]
