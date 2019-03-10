Class {
	#name : #MbndAstLiteralValue,
	#superclass : #MbndAstNode,
	#instVars : [
		'value',
		'type'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLiteralValue >> accept: aVisitor [
	^ aVisitor visitLiteralNode: self
]

{ #category : #accessing }
MbndAstLiteralValue >> type [
	^ type
]

{ #category : #accessing }
MbndAstLiteralValue >> type: anObject [
	type := anObject
]

{ #category : #accessing }
MbndAstLiteralValue >> value [
	^ value
]

{ #category : #accessing }
MbndAstLiteralValue >> value: anObject [
	value := anObject
]
