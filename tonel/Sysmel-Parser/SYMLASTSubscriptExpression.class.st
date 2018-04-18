Class {
	#name : #SYMLASTSubscriptExpression,
	#superclass : #SYMLASTNode,
	#instVars : [
		'container',
		'index'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #converting }
SYMLASTSubscriptExpression >> buildAPSG: builder [
	^ (builder send: #subscriptAt:
		to: (container buildAPSG: builder)
		withArguments: {index buildAPSG: builder})
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
