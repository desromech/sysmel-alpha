Class {
	#name : #MbndAstImplicitCastNode,
	#superclass : #MbndAstGenericCastNode,
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
