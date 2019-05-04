Class {
	#name : #MbndMacroExpansionRuleMetaBuilder,
	#superclass : #MbndAbstractMessageMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndMacroExpansionRuleMetaBuilder >> createMessageDefinition [
	self ensureMessagePrototype.
	messageDefinition := MbndAstMacroMessageDefinitionNode new
		position: position;
		prototype: messagePrototype;
		yourself
]

{ #category : #'as yet unclassified' }
MbndMacroExpansionRuleMetaBuilder >> ensureMessagePrototype [
	messagePrototype ifNotNil: [ ^ self ].
	messagePrototype := MbndAstMacroMessagePrototypeNode new
		position: position;
		ownerProgramEntity: ownerProgramEntity;
		flags: flags;
		selector: messageSelector;
		arguments: messageArguments;
		returnType: returnTypeNode;
		yourself
]
