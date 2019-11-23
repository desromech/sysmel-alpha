Class {
	#name : #MbndAstMatrixConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matrixType',
		'columns'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixConstructionNode >> accept: visitor [
	^ visitor visitMatrixConstructionNode: self
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> columns [
	^ columns
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> columns: anObject [
	columns := anObject
]

{ #category : #testing }
MbndAstMatrixConstructionNode >> isMatrixConstructionNode [
	^ true
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> matrixType [
	^ matrixType
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> matrixType: anObject [
	matrixType := anObject
]
