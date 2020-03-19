Class {
	#name : #MbndAstNamespaceDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstNamespaceDefinitionNode >> accept: aVisitor [
	^ aVisitor visitNamespaceDefinitionNode: self
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstNamespaceDefinitionNode >> body: anObject [
	body := anObject
]

{ #category : #serialization }
MbndAstNamespaceDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#body . body encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstNamespaceDefinitionNode >> isNamespaceDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstNamespaceDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	body := encodedFields at: #body.
]
