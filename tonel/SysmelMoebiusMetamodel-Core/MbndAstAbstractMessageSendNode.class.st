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
