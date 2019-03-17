Class {
	#name : #MbndAstIfConditionNode,
	#superclass : #MbndAstNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIfConditionNode >> accept: aVisitor [
	^ aVisitor visitIfConditionNode: self
]
