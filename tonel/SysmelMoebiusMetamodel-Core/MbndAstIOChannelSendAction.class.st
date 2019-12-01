Class {
	#name : #MbndAstIOChannelSendAction,
	#superclass : #MbndAstIOChannelAction,
	#instVars : [
		'message'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIOChannelSendAction >> accept: visitor [
	^ visitor visitIOChannelSendAction: self
]

{ #category : #testing }
MbndAstIOChannelSendAction >> isIOChannelSendActionNode [
	^ true
]

{ #category : #accessing }
MbndAstIOChannelSendAction >> message [
	^ message
]

{ #category : #accessing }
MbndAstIOChannelSendAction >> message: anObject [
	message := anObject
]
