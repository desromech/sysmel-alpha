Class {
	#name : #MbndAstCompileTimeConstantDefinitionNode,
	#superclass : #MbndAstSymbolDefinition,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstCompileTimeConstantDefinitionNode >> accept: aVisitor [
	^ aVisitor visitCompileTimeConstantDefinitionNode: self
]

{ #category : #serialization }
MbndAstCompileTimeConstantDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstCompileTimeConstantDefinitionNode >> isCompileTimeConstantDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstCompileTimeConstantDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstCompileTimeConstantDefinitionNode >> value: anObject [
	value := anObject
]
