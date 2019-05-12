Class {
	#name : #MbndAstIntegerToFloatingPointCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIntegerToFloatingPointCastNode >> accept: aVisitor [
	^ aVisitor visitIntegerToFloatingPointCastNode: self
]

{ #category : #testing }
MbndAstIntegerToFloatingPointCastNode >> isIntegerToFloatingPointCastNode [
	^ true
]
