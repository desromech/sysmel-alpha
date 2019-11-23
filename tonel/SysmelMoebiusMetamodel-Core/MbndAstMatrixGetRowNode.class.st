Class {
	#name : #MbndAstMatrixGetRowNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixGetRowNode >> accept: visitor [
	^ visitor visitMatrixGetRowNode: self
]

{ #category : #testing }
MbndAstMatrixGetRowNode >> isMatrixGetRowNode [
	^ true
]
