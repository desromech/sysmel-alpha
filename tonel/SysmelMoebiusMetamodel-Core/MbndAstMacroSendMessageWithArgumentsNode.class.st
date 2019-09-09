Class {
	#name : #MbndAstMacroSendMessageWithArgumentsNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroSendMessageWithArgumentsNode >> accept: aVisitor [
	^ aVisitor visitMacroSendMessageWithArgumentsNode: self
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #testing }
MbndAstMacroSendMessageWithArgumentsNode >> isMacroSendMessageWithArgumentsNode [
	^ true
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> selector: anObject [
	selector := anObject
]
