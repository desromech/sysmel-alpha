Class {
	#name : #MbndAstExpandedDynamicMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandedDynamicMessageSendNode >> accept: aVisitor [
	^ aVisitor visitExpandedDynamicMessageSendNode: self
]

{ #category : #testing }
MbndAstExpandedDynamicMessageSendNode >> isExpandedDynamicMessageSendNode [
	^ true
]
