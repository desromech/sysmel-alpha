Class {
	#name : #SysmelLiteralASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteral: self
]

{ #category : #generated }
SysmelLiteralASTNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
SysmelLiteralASTNode >> value [
	^ value
]

{ #category : #generated }
SysmelLiteralASTNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
