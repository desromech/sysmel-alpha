Class {
	#name : #MbndAstPointerElementReferenceNode,
	#superclass : #MbndAstSubscriptElementReferenceNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerElementReferenceNode >> accept: aVisitor [
	^ aVisitor visitPointerElementReferenceNode: self
]

{ #category : #testing }
MbndAstPointerElementReferenceNode >> isPointerElementReferenceNode [
	^ true
]
