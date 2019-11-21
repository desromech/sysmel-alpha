Class {
	#name : #MbndAstAbstractVectorAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'vector',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> elements: anObject [
	elements := anObject
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> vector [
	^ vector
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> vector: anObject [
	vector := anObject
]
