Class {
	#name : #SysmelMessageChainASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'firstMessage',
		'receiver',
		'chainedMessages',
		'semicolons'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelMessageChainASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitMessageChain: self
]

{ #category : #generated }
SysmelMessageChainASTNode >> chainedMessages [
	^ chainedMessages
]

{ #category : #generated }
SysmelMessageChainASTNode >> chainedMessages: anOrderedCollection [
	self setParents: self chainedMessages to: nil.
	chainedMessages := anOrderedCollection.
	self setParents: self chainedMessages to: self
]

{ #category : #generated }
SysmelMessageChainASTNode >> compositeNodeVariables [
	^ #(#chainedMessages)
]

{ #category : #generated }
SysmelMessageChainASTNode >> compositeTokenVariables [
	^ #(#semicolons)
]

{ #category : #generated }
SysmelMessageChainASTNode >> firstMessage [
	^ firstMessage
]

{ #category : #generated }
SysmelMessageChainASTNode >> firstMessage: aSysmelKeywordMessageASTNode [
	self firstMessage notNil
		ifTrue: [ self firstMessage parent: nil ].
	firstMessage := aSysmelKeywordMessageASTNode.
	self firstMessage notNil
		ifTrue: [ self firstMessage parent: self ]
]

{ #category : #'generated-initialize-release' }
SysmelMessageChainASTNode >> initialize [
	super initialize.
	semicolons := OrderedCollection new: 2.
	chainedMessages := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelMessageChainASTNode >> nodeVariables [
	^ #(#firstMessage #receiver)
]

{ #category : #generated }
SysmelMessageChainASTNode >> receiver [
	^ receiver
]

{ #category : #generated }
SysmelMessageChainASTNode >> receiver: aSysmelExpressionASTNode [
	self receiver notNil
		ifTrue: [ self receiver parent: nil ].
	receiver := aSysmelExpressionASTNode.
	self receiver notNil
		ifTrue: [ self receiver parent: self ]
]

{ #category : #generated }
SysmelMessageChainASTNode >> semicolons [
	^ semicolons
]

{ #category : #generated }
SysmelMessageChainASTNode >> semicolons: anOrderedCollection [
	semicolons := anOrderedCollection
]
