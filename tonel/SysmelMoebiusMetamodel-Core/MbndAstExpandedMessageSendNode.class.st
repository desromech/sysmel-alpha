Class {
	#name : #MbndAstExpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandedMessageSendNode >> accept: aVisitor [
	^ aVisitor visitExpandedMessageSendNode: self
]

{ #category : #testing }
MbndAstExpandedMessageSendNode >> isExpandedMessageSendNode [
	^ true
]
