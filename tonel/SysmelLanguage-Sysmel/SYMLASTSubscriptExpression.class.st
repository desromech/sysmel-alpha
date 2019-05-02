Class {
	#name : #SYMLASTSubscriptExpression,
	#superclass : #SYMLASTNode,
	#instVars : [
		'container',
		'index'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTSubscriptExpression >> buildMoebiusAST: builder [
	^ (builder unexpandedSend: (builder literalSymbol: #subscriptAt:)
		to: (container buildMoebiusAST: builder)
		withArguments: {index buildMoebiusAST: builder})
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTSubscriptExpression >> children [
	^ { 
		container.
		index.
	}
]

{ #category : #accessing }
SYMLASTSubscriptExpression >> container [
	^ container
]

{ #category : #accessing }
SYMLASTSubscriptExpression >> container: anObject [
	container := anObject
]

{ #category : #accessing }
SYMLASTSubscriptExpression >> index [
	^ index
]

{ #category : #accessing }
SYMLASTSubscriptExpression >> index: anObject [
	index := anObject
]

{ #category : #'as yet unclassified' }
SYMLASTSubscriptExpression >> withReceiver: aReceiver [
	container := aReceiver
]
