Class {
	#name : #MbndAstNumberToBooleanCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstNumberToBooleanCastNode >> accept: aVisitor [
	^ aVisitor visitNumberToBooleanCastNode: self
]

{ #category : #testing }
MbndAstNumberToBooleanCastNode >> isNumberToBooleanCastNode [
	^ true
]
