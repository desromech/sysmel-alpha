Class {
	#name : #MbndAstMessageChainNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageChainNode >> accept: aVisitor [
	^ aVisitor visitMessageChainNode: self
]

{ #category : #converting }
MbndAstMessageChainNode >> asPrettySymbolName [
	^ 'Message chain receiver'
]

{ #category : #converting }
MbndAstMessageChainNode >> isMbndGenerateSymbolRemovedFromDebug [
	^ true
]

{ #category : #testing }
MbndAstMessageChainNode >> isMessageChainNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstMessageChainNode >> markStorageCreationNodeForCopyEllision: node [
	self shouldNotImplement
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
