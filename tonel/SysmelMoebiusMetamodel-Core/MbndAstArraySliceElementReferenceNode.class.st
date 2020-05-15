Class {
	#name : #MbndAstArraySliceElementReferenceNode,
	#superclass : #MbndAstSubscriptElementReferenceNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstArraySliceElementReferenceNode >> accept: aVisitor [
	^ aVisitor visitArraySliceElementReferenceNode: self
]

{ #category : #testing }
MbndAstArraySliceElementReferenceNode >> isArraySliceElementReferenceNode [
	^ true
]
