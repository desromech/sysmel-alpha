Class {
	#name : #MbndAstMatrixMultiplicationOperationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'leftMatrix',
		'rightMatrix'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixMultiplicationOperationNode >> accept: visitor [
	^ visitor visitMatrixMultiplicationOperationNode: self
]

{ #category : #testing }
MbndAstMatrixMultiplicationOperationNode >> isMatrixMultiplicationOperationNode [
	^ true
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> leftMatrix [
	^ leftMatrix
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> leftMatrix: anObject [
	leftMatrix := anObject
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> rightMatrix [
	^ rightMatrix
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> rightMatrix: anObject [
	rightMatrix := anObject
]
