Class {
	#name : #SysmelIdentifierReferenceASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'symbol'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelIdentifierReferenceASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitIdentifierReference: self
]

{ #category : #generated }
SysmelIdentifierReferenceASTNode >> symbol [
	^ symbol
]

{ #category : #generated }
SysmelIdentifierReferenceASTNode >> symbol: aSmaCCToken [
	symbol := aSmaCCToken
]

{ #category : #generated }
SysmelIdentifierReferenceASTNode >> tokenVariables [
	^ #(#symbol)
]
