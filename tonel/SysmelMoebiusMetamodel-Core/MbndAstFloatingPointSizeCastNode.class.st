Class {
	#name : #MbndAstFloatingPointSizeCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFloatingPointSizeCastNode >> accept: aVisitor [
	^ aVisitor visitFloatingPointSizeCastNode: self
]

{ #category : #testing }
MbndAstFloatingPointSizeCastNode >> isFloatingPointSizeCastNode [
	^ true
]
