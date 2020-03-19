Class {
	#name : #MbndAstMacroSendMessageWithArgumentsNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroSendMessageWithArgumentsNode >> accept: aVisitor [
	^ aVisitor visitMacroSendMessageWithArgumentsNode: self
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #serialization }
MbndAstMacroSendMessageWithArgumentsNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#receiver . receiver encodeGraphForMessagePackWith: graphEncoder.
		#selector . selector encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMacroSendMessageWithArgumentsNode >> isMacroSendMessageWithArgumentsNode [
	^ true
]

{ #category : #serialization }
MbndAstMacroSendMessageWithArgumentsNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	receiver := encodedFields at: #receiver.
	selector := encodedFields at: #selector.
	arguments := encodedFields at: #arguments.
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMacroSendMessageWithArgumentsNode >> selector: anObject [
	selector := anObject
]
