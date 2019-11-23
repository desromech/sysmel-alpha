Class {
	#name : #MbndAstAbstractMatrixAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matrix',
		'element'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> element [
	^ element
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> element: anObject [
	element := anObject
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> matrix [
	^ matrix
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> matrix: anObject [
	matrix := anObject
]
