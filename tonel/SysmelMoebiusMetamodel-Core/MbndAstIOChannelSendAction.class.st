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

{ #category : #serialization }
MbndAstIOChannelSendAction >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#message . message encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstIOChannelSendAction >> isIOChannelSendActionNode [
	^ true
]

{ #category : #serialization }
MbndAstIOChannelSendAction >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	message := encodedFields at: #message.
]

{ #category : #accessing }
MbndAstIOChannelSendAction >> message [
	^ message
]

{ #category : #accessing }
MbndAstIOChannelSendAction >> message: anObject [
	message := anObject
]
