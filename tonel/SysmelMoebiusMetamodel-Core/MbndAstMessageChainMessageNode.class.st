Class {
	#name : #MbndAstMessageChainMessageNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMessageChainMessageNode >> accept: aVisitor [
	^ aVisitor visitMessageChainMessageNode: self
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
MbndAstMessageChainMessageNode >> asUnexpandedMessageSend [
	^ MbndAstUnexpandedMessageSendNode new
		position: self;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #serialization }
MbndAstMessageChainMessageNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#selector . selector encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMessageChainMessageNode >> isMessageChainMessageNode [
	^ true
]

{ #category : #serialization }
MbndAstMessageChainMessageNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	selector := encodedFields at: #selector.
	arguments := encodedFields at: #arguments.
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector: anObject [
	selector := anObject
]
