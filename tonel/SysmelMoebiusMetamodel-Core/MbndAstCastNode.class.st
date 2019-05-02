Class {
	#name : #MbndAstCastNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'targetType',
		'castingRule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstCastNode >> castingRule [
	^ castingRule
]

{ #category : #accessing }
MbndAstCastNode >> castingRule: anObject [
	castingRule := anObject
]

{ #category : #accessing }
MbndAstCastNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstCastNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstCastNode >> isCastNode [
	^ true
]

{ #category : #accessing }
MbndAstCastNode >> targetType [
	^ targetType
]

{ #category : #accessing }
MbndAstCastNode >> targetType: anObject [
	targetType := anObject
]
