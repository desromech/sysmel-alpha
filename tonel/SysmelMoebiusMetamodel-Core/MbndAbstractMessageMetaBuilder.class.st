Class {
	#name : #MbndAbstractMessageMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#instVars : [
		'messageArguments',
		'returnTypeNode',
		'messageSelector',
		'messageDefinition',
		'messagePrototype'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndAbstractMessageMetaBuilder >> => aReturnType [
	messageArguments ifNil: [ self error: 'The message return type must be specified after the message arguments.' ].
	returnTypeNode := aReturnType.
	self ensureMessagePrototype
]

{ #category : #'semantic analysis' }
MbndAbstractMessageMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	messageArguments ifNil: [
		node selector isLiteralSymbolValueNode ifFalse: [ 
			self error: 'Expected a literal message selector.'
		].
	
		messageSelector := node selector value.
		messageArguments := node arguments collect: [ :arg | arg parseAsArgumentDefinition ].
		^ node receiver
	].

	^ super analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #definition }
MbndAbstractMessageMetaBuilder >> assignValue: aNode [
	^ self definition: aNode
]

{ #category : #'semantic analysis' }
MbndAbstractMessageMetaBuilder >> concretizeNodeAt: node withAnalyzer: analyzer [
	self ensureMessagePrototype.
	
	^ analyzer visitNode: (messageDefinition
		ifNotNil: [ messageDefinition ]
		ifNil: [ messagePrototype ])
]

{ #category : #'as yet unclassified' }
MbndAbstractMessageMetaBuilder >> createMessageDefinition [
	self ensureMessagePrototype.
	messageDefinition := MbndAstMessageMethodDefinitionNode new
		position: position;
		prototype: messagePrototype;
		yourself
]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> definition: aNode [
	(messageDefinition isNotNil and: [messageDefinition body isNotNil]) ifTrue: [
		 ^ self abortMetaBuilding
	].

	messagePrototype ifNil: [ self ensureMessagePrototype  ].
	self createMessageDefinition.
	messageDefinition body: aNode
]

{ #category : #'as yet unclassified' }
MbndAbstractMessageMetaBuilder >> ensureMessagePrototype [
	messagePrototype ifNotNil: [ ^ self ].
	messagePrototype := MbndAstMessageMethodPrototypeNode new
		position: position;
		ownerProgramEntity: ownerProgramEntity;
		flags: flags;
		selector: messageSelector;
		arguments: messageArguments;
		returnType: returnTypeNode;
		yourself
]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> messageArguments [
	^ messageArguments
]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> messageArguments: anObject [
	messageArguments := anObject
]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> ownerProgramEntity: newOwner [
	super ownerProgramEntity: newOwner.
	messagePrototype ifNotNil: [ messagePrototype ownerProgramEntity: newOwner ]
]

{ #category : #copying }
MbndAbstractMessageMetaBuilder >> postCopy [
	messagePrototype := messagePrototype copy.
	messageDefinition ifNotNil: [ 
		messageDefinition := messageDefinition copy.
		messageDefinition prototype: messagePrototype
	]

]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> returnTypeNode [
	^ returnTypeNode
]

{ #category : #accessing }
MbndAbstractMessageMetaBuilder >> returnTypeNode: anObject [
	returnTypeNode := anObject
]
