Class {
	#name : #MbndAstImplicitCastNode,
	#superclass : #MbndAstCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstImplicitCastNode >> accept: aVisitor [
	^ aVisitor visitImplicitCastNode: self
]

{ #category : #testing }
MbndAstImplicitCastNode >> isImplicitCastNode [
	^ true
]
