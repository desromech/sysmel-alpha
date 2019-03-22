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

{ #category : #converting }
MbndAstAbstractMessageSendNode >> asExpandedMessageSend [
	^ MbndAstExpandedMessageSendNode new
		position: position;
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #converting }
MbndAstAbstractMessageSendNode >> asUnexpandedMessageSend [
	^ MbndAstUnexpandedMessageSendNode new
		position: position;
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
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
