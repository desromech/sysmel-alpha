Class {
	#name : #MbndAstIOChannelReceiveAction,
	#superclass : #MbndAstIOChannelAction,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIOChannelReceiveAction >> accept: visitor [
	^ visitor visitIOChannelReceiveAction: self
]

{ #category : #testing }
MbndAstIOChannelReceiveAction >> isIOChannelReceiveActionNode [
	^ true
]
