Class {
	#name : #MbndAstExpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#instVars : [
		'method'
	],
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

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> method [
	^ method
]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> method: anObject [
	method := anObject
]
