Class {
	#name : #MbndAstUnexpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstUnexpandedMessageSendNode >> accept: aVisitor [
	^ aVisitor visitUnexpandedMessageSendNode: self
]
