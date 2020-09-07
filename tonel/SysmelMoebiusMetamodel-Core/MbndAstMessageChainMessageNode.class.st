Class {
	#name : #MbndAstMessageChainMessageNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
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
		flags: self flags;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #serialization }
MbndAstMessageChainMessageNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#selector . selector encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#flags . flags
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
	flags := encodedFields at: #flags.
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMessageChainMessageNode >> selector: anObject [
	selector := anObject
]

{ #category : #asserting }
MbndAstMessageChainMessageNode >> shouldBeExpandedToDynamicMessage [
	^ self hasFlag: #shouldBeExpandedToDynamicMessage
]

{ #category : #asserting }
MbndAstMessageChainMessageNode >> shouldBeExpandedToDynamicMessage: value [
	^ self setFlag: #shouldBeExpandedToDynamicMessage value: value
]
