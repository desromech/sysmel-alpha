Class {
	#name : #MbndAstExpandedHostMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandedHostMessageSendNode >> accept: aVisitor [
	^ aVisitor visitExpandedHostMessageSendNode: self
]

{ #category : #testing }
MbndAstExpandedHostMessageSendNode >> isExpandedHostMessageSendNode [
	^ true
]
