Class {
	#name : #MbndAstPointerToIntegerCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerToIntegerCastNode >> accept: aVisitor [
	^ aVisitor visitPointerToIntegerCastNode: self


]

{ #category : #testing }
MbndAstPointerToIntegerCastNode >> isPointerToIntegerCastNode [
	^ true
]
