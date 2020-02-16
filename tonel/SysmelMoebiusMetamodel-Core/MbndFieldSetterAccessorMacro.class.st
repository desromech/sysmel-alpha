Class {
	#name : #MbndFieldSetterAccessorMacro,
	#superclass : #MbndAbstractFieldAccessorMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #converting }
MbndFieldSetterAccessorMacro >> createMethodAccessorForReceiver: receiverType withSelector: accessorSelector [
	| astBuilder methodDefinitionNode newValue |
	field name isMbndAnonymousSymbol ifTrue: [ ^ self ].
	field valueType canHaveDynamicMethodWrapper ifFalse: [ ^ self ].
	(field valueType isReferenceType or: [ field valueType isTemporaryReferenceType ]) ifTrue: [ ^ self ].

	astBuilder := (MbndAstBuilder forModule: field module) gensymContext: field; yourself.
	astBuilder defaultPosition: field definitionPosition.
	newValue := astBuilder gensym: #newValue.
	
	methodDefinitionNode := astBuilder messageSelector: accessorSelector
		arguments: { astBuilder argument: newValue type: field valueType } returnType: field valueType
		definitionBody: (
			astBuilder unexpandedSend: (astBuilder literalSymbol: #assignValue:)
				to: (astBuilder identifier: field name)
				withArguments: {newValue}).
	methodDefinitionNode prototype ownerProgramEntity: receiverType.
	
	(MbndAstSemanticAnalyzer new 
		module: field module;
		scope: field definitionScope;
		yourself)
		visitNode: methodDefinitionNode
]

{ #category : #'as yet unclassified' }
MbndFieldSetterAccessorMacro >> expandMessageNode: node with: analyzer [
	self assert: node arguments size = 1.
	^ analyzer visitNode: (MbndAstSetFieldValueNode new
		position: node;
		aggregate: node receiver;
		field: field;
		newValue: node arguments first;
		yourself)
]
