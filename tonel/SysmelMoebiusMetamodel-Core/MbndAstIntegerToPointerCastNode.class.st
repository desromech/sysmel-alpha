Class {
	#name : #MbndAstIntegerToPointerCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIntegerToPointerCastNode >> accept: aVisitor [
	^ aVisitor visitIntegerToPointerCastNode: self
]

{ #category : #testing }
MbndAstIntegerToPointerCastNode >> isIntegerToPointerCastNode [
	^ true
]
