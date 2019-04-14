Class {
	#name : #MbndAstUnexpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstUnexpandedMessageSendNode >> accept: aVisitor [
	^ aVisitor visitUnexpandedMessageSendNode: self
]

{ #category : #testing }
MbndAstUnexpandedMessageSendNode >> isUnexpandedMessageSendNode [
	^ true
]
