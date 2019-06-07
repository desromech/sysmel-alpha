Class {
	#name : #MbndAstPointerReinterpretCastNode,
	#superclass : #MbndAstPointerCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerReinterpretCastNode >> accept: aVisitor [
	^ aVisitor visitPointerReinterpretCastNode: self
]

{ #category : #testing }
MbndAstPointerReinterpretCastNode >> isPointerReinterpretCastNode [
	^ true
]
