Class {
	#name : #MbndAstTruncateCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTruncateCastNode >> accept: aVisitor [
	^ aVisitor visitTruncateCastNode: self
]

{ #category : #testing }
MbndAstTruncateCastNode >> isTruncateCastNode [
	^ true
]
