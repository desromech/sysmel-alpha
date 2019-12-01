Class {
	#name : #MbndAstIOChannelAction,
	#superclass : #MbndAstNode,
	#instVars : [
		'channel'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstIOChannelAction >> channel [
	^ channel
]

{ #category : #accessing }
MbndAstIOChannelAction >> channel: anObject [
	channel := anObject
]

{ #category : #testing }
MbndAstIOChannelAction >> isIOChannelActionNode [
	^ true
]
