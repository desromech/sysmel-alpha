Class {
	#name : #MbndAstAbstractMessageSendNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> selector: anObject [
	selector := anObject
]
