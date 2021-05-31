Class {
	#name : #MbndAstMacroSendMessageNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'message'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroSendMessageNode >> accept: aVisitor [
	^ aVisitor visitMacroSendMessageNode: self
]

{ #category : #serialization }
MbndAstMacroSendMessageNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#receiver . receiver encodeGraphForMessagePackWith: graphEncoder.
		#message . message encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #visiting }
MbndAstMacroSendMessageNode >> isMacroSendMessageNode [
	^ true
]

{ #category : #serialization }
MbndAstMacroSendMessageNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	receiver := encodedFields at: #receiver.
	message := encodedFields at: #message.
]

{ #category : #accessing }
MbndAstMacroSendMessageNode >> message [

	^ message
]

{ #category : #accessing }
MbndAstMacroSendMessageNode >> message: anObject [

	message := anObject
]

{ #category : #accessing }
MbndAstMacroSendMessageNode >> receiver [

	^ receiver
]

{ #category : #accessing }
MbndAstMacroSendMessageNode >> receiver: anObject [

	receiver := anObject
]
