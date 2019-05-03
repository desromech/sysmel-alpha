Class {
	#name : #MbndAstArrayElementReferenceNode,
	#superclass : #MbndAstSubscriptElementReferenceNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArrayElementReferenceNode >> accept: aVisitor [
	^ aVisitor visitArrayElementReferenceNode: self
]

{ #category : #testing }
MbndAstArrayElementReferenceNode >> isArrayElementReferenceNode [
	^ true
]
