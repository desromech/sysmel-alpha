Class {
	#name : #MbndAstCaughtExceptionReferenceNode,
	#superclass : #MbndAstSymbolReference,
	#instVars : [
		'catchExpressionNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCaughtExceptionReferenceNode >> accept: aVisitor [
	^ aVisitor visitCaughtExceptionReferenceNode: self
]

{ #category : #accessing }
MbndAstCaughtExceptionReferenceNode >> catchExpressionNode [
	^ catchExpressionNode
]

{ #category : #accessing }
MbndAstCaughtExceptionReferenceNode >> catchExpressionNode: anObject [
	catchExpressionNode := anObject
]

{ #category : #testing }
MbndAstCaughtExceptionReferenceNode >> isCaughtExceptionReferenceNode [
	^ true
]
