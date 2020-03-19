Class {
	#name : #MbndAstAbstractMessageSendNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
MbndAstAbstractMessageSendNode >> asExpandedDynamicMessageSend [
	^ MbndAstExpandedDynamicMessageSendNode new
		position: position;
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #converting }
MbndAstAbstractMessageSendNode >> asExpandedMessageSend [
	^ MbndAstExpandedMessageSendNode new
		position: position;
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #converting }
MbndAstAbstractMessageSendNode >> asUnexpandedMessageSend [
	^ MbndAstUnexpandedMessageSendNode new
		position: position;
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #serialization }
MbndAstAbstractMessageSendNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#receiver . receiver encodeGraphForMessagePackWith: graphEncoder.
		#selector . selector encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstAbstractMessageSendNode >> hasOnlyLiterals [
	receiver ifNotNil: [ 
		receiver isLiteralValueNode ifFalse: [ ^ false ]
	].

	arguments do: [ :arg |
		arg isLiteralValueNode ifFalse: [ ^ false ]
	].

	^ true
	
]

{ #category : #serialization }
MbndAstAbstractMessageSendNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	receiver := encodedFields at: #receiver.
	selector := encodedFields at: #selector.
	arguments := encodedFields at: #arguments.
]

{ #category : #parsing }
MbndAstAbstractMessageSendNode >> parseAsArgumentDefinition [
	| argumentName |
	selector isLiteralSymbolValueNode ifFalse: [ ^ super parseAsArgumentDefinition].
	receiver ifNotNil: [ ^ super parseAsArgumentDefinition].
	selector value numArgs ~= 1 ifTrue: [ ^ super parseAsArgumentDefinition ].

	argumentName := selector value allButLast asSymbol.
	^ MbndAstArgumentDefinitionNode new
		position: self;
		name: argumentName;
		valueType: arguments first;
		yourself
]

{ #category : #parsing }
MbndAstAbstractMessageSendNode >> parseAsFunctionArgumentsPrototype [
	^ { self parseAsArgumentDefinition }
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> receiver [
	^ receiver
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstAbstractMessageSendNode >> selector: anObject [
	selector := anObject
]
