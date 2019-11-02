Class {
	#name : #MbndAstConcretizeUndefinedValueCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstConcretizeUndefinedValueCastNode >> accept: aVisitor [
	^ aVisitor visitConcretizeUndefinedValueCastNode: self
]

{ #category : #testing }
MbndAstConcretizeUndefinedValueCastNode >> isConcretizeUndefinedValueCastNode [
	^ true
]
