Class {
	#name : #MbndAstFloatingPointToIntegerCastNode,
	#superclass : #MbndAstNumericalCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFloatingPointToIntegerCastNode >> accept: aVisitor [
	^ aVisitor visitFloatingPointToIntegerCastNode: self
]

{ #category : #testing }
MbndAstFloatingPointToIntegerCastNode >> isFloatingPointToIntegerCastNode [
	^ true
]
