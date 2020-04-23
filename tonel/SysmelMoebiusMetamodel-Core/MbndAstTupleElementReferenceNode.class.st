Class {
	#name : #MbndAstTupleElementReferenceNode,
	#superclass : #MbndAstSubscriptElementReferenceNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTupleElementReferenceNode >> accept: aVisitor [
	^ aVisitor visitTupleElementReferenceNode: self
]

{ #category : #testing }
MbndAstTupleElementReferenceNode >> isTupleElementReferenceNode [
	^ true
]
