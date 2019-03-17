Class {
	#name : #MbndAstMessageChainNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'MoebiusBandMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageChainNode >> accept: aVisitor [
	^ aVisitor visitMessageChainNode: self
]

{ #category : #testing }
MbndAstMessageChainNode >> isMessageChainNode [
	^ true
]

{ #category : #accessing }
MbndAstMessageChainNode >> messages [
	^ messages
]

{ #category : #accessing }
MbndAstMessageChainNode >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
MbndAstMessageChainNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstMessageChainNode >> receiver: anObject [
	receiver := anObject
]
