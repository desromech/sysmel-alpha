Class {
	#name : #MbndAstMessageChainNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageChainNode >> accept: aVisitor [
	^ aVisitor visitMessageChainNode: self
]

{ #category : #converting }
MbndAstMessageChainNode >> asPrettySymbolName [
	^ 'Message chain receiver'
]

{ #category : #serialization }
MbndAstMessageChainNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#receiver . receiver encodeGraphForMessagePackWith: graphEncoder.
		#messages . messages encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #converting }
MbndAstMessageChainNode >> isMbndGenerateSymbolRemovedFromDebug [
	^ true
]

{ #category : #testing }
MbndAstMessageChainNode >> isMessageChainNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstMessageChainNode >> markStorageCreationNodeForCopyEllision: node [
	self shouldNotImplement
]

{ #category : #serialization }
MbndAstMessageChainNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	receiver := encodedFields at: #receiver.
	messages := encodedFields at: #messages.
]

{ #category : #accessing }
MbndAstMessageChainNode >> messages [
	^ messages
]

{ #category : #accessing }
MbndAstMessageChainNode >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
MbndAstMessageChainNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstMessageChainNode >> receiver: anObject [
	receiver := anObject
]
