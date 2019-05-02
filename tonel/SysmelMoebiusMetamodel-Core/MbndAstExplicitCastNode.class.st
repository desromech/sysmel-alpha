Class {
	#name : #MbndAstExplicitCastNode,
	#superclass : #MbndAstCastNode,
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
