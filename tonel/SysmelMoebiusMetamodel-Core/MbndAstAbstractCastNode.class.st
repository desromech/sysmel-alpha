Class {
	#name : #MbndAstAbstractCastNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'targetType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractCastNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstAbstractCastNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstAbstractCastNode >> isAbstractCastNode [
	^ true
]

{ #category : #accessing }
MbndAstAbstractCastNode >> targetType [
	^ targetType
]

{ #category : #accessing }
MbndAstAbstractCastNode >> targetType: anObject [
	targetType := anObject
]
