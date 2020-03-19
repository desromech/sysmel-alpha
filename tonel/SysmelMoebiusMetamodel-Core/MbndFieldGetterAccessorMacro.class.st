Class {
	#name : #MbndFieldGetterAccessorMacro,
	#superclass : #MbndAbstractFieldAccessorMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndFieldGetterAccessorMacro class >> messagePackTypeName [
	^ #MacroFieldGetter
]

{ #category : #converting }
MbndFieldGetterAccessorMacro >> createMethodAccessorForReceiver: receiverType withSelector: accessorSelector [
	| astBuilder methodDefinitionNode |
	field name isMbndAnonymousSymbol ifTrue: [ ^ self ].
	field valueType canHaveDynamicMethodWrapper ifFalse: [ ^ self ].

	astBuilder := MbndAstBuilder forModule: field module.
	astBuilder defaultPosition: field definitionPosition.
	methodDefinitionNode := astBuilder messageSelector: accessorSelector arguments: #() returnType: field valueType definitionBody: (astBuilder identifier: field name).
	methodDefinitionNode prototype ownerProgramEntity: receiverType.
	
	(MbndAstSemanticAnalyzer new 
		module: field module;
		scope: field definitionScope;
		yourself)
		visitNode: methodDefinitionNode
]

{ #category : #serialization }
MbndFieldGetterAccessorMacro >> encodeFieldsForMessagePackWith: graphEncoder [
	^ { 
		#field . field encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #'as yet unclassified' }
MbndFieldGetterAccessorMacro >> expandMessageNode: node with: analyzer [
	| receiverType |
	receiverType := node receiver type withoutTopDecorations.
	receiverType isReferenceLikeValueType ifTrue: [
		^ analyzer visitNode: (MbndAstGetFieldReferenceNode new
			aggregate: node receiver;
			field: field;
			yourself)
	].
	
	^ analyzer visitNode: (MbndAstGetFieldValueNode new
		aggregate: node receiver;
		field: field;
		yourself)

]

{ #category : #serialization }
MbndFieldGetterAccessorMacro >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	field := encodedFields at: #field.
]
