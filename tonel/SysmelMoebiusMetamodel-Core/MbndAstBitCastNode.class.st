Class {
	#name : #MbndAstBitCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBitCastNode >> accept: aVisitor [
	^ aVisitor visitBitCastNode: self
]

{ #category : #testing }
MbndAstBitCastNode >> isBitCastNode [
	^ true
]
