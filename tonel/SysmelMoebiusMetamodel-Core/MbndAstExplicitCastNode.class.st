Class {
	#name : #MbndAstExplicitCastNode,
	#superclass : #MbndAstGenericCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExplicitCastNode >> accept: aVisitor [
	^ aVisitor visitExplicitCastNode: self
]

{ #category : #testing }
MbndAstExplicitCastNode >> isExplicitCastNode [
	^ true
]
