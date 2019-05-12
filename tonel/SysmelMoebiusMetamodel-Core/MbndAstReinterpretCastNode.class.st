Class {
	#name : #MbndAstReinterpretCastNode,
	#superclass : #MbndAstGenericCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReinterpretCastNode >> accept: aVisitor [
	^ aVisitor visitReinterpretCastNode: self
]

{ #category : #testing }
MbndAstReinterpretCastNode >> isReinterpretCastNode [
	^ true
]
