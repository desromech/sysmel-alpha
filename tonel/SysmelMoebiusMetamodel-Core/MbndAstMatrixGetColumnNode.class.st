Class {
	#name : #MbndAstMatrixGetColumnNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixGetColumnNode >> accept: visitor [
	^ visitor visitMatrixGetColumnNode: self
]

{ #category : #testing }
MbndAstMatrixGetColumnNode >> isMatrixGetColumnNode [
	^ true
]
