Class {
	#name : #MbndAstFunctionCallNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'function',
		'arguments'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFunctionCallNode >> accept: aVisitor [
	^ aVisitor visitFunctionCallNode: self
]

{ #category : #accessing }
MbndAstFunctionCallNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstFunctionCallNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstFunctionCallNode >> function [
	^ function
]

{ #category : #accessing }
MbndAstFunctionCallNode >> function: anObject [
	function := anObject
]

{ #category : #testing }
MbndAstFunctionCallNode >> isFunctionCallNode [
	^ true
]
