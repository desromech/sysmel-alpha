Class {
	#name : #MbndAstSpliceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSpliceNode >> accept: aVisitor [
	^ aVisitor visitSpliceNode: self
]

{ #category : #accessing }
MbndAstSpliceNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstSpliceNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstSpliceNode >> isSpliceNode [
	^ true
]
