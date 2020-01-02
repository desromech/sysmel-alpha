Class {
	#name : #MbndMacroMethodMetaBuilder,
	#superclass : #MbndAbstractMessageMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndMacroMethodMetaBuilder >> createMessageDefinition [
	self ensureMessagePrototype.
	messageDefinition := MbndAstMacroMessageMethodDefinitionNode new
		position: position;
		prototype: messagePrototype;
		yourself
]

{ #category : #'as yet unclassified' }
MbndMacroMethodMetaBuilder >> ensureMessagePrototype [
	messagePrototype ifNotNil: [ ^ self ].
	messagePrototype := MbndAstMacroMessageMethodPrototypeNode new
		position: position;
		ownerProgramEntity: ownerProgramEntity;
		flags: flags;
		selector: messageSelector;
		arguments: messageArguments;
		returnType: returnTypeNode;
		yourself
]
