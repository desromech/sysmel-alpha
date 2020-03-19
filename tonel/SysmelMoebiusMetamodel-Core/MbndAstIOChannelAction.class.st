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

{ #category : #serialization }
MbndAstIOChannelAction >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#channel . channel encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstIOChannelAction >> isIOChannelActionNode [
	^ true
]

{ #category : #serialization }
MbndAstIOChannelAction >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	channel := encodedFields at: #channel.
]
