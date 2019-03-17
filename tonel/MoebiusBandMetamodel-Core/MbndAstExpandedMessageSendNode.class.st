Class {
	#name : #MbndAstExpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandedMessageSendNode >> accept: aVisitor [
	^ aVisitor visitExpandedMessageSendNode: self
]
