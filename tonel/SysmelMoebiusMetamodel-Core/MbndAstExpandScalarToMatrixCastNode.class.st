Class {
	#name : #MbndAstExpandScalarToMatrixCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandScalarToMatrixCastNode >> accept: visitor [
	^ visitor visitExpandScalarToMatrixCastNode: self
]

{ #category : #testing }
MbndAstExpandScalarToMatrixCastNode >> isExpandScalarToMatrixCastNode [
	^ true
]
