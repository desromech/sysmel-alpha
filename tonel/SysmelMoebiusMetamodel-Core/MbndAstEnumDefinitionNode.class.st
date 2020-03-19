Class {
	#name : #MbndAstEnumDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#instVars : [
		'valueType',
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstEnumDefinitionNode >> accept: aVisitor [
	^ aVisitor visitEnumDefinitionNode: self
]

{ #category : #serialization }
MbndAstEnumDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#valueType . valueType encodeGraphForMessagePackWith: graphEncoder.
		#values . values encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstEnumDefinitionNode >> isEnumDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstEnumDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	valueType := encodedFields at: #valueType.
	values := encodedFields at: #values.
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> valueType: anObject [
	valueType := anObject
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> values [
	^ values
]

{ #category : #accessing }
MbndAstEnumDefinitionNode >> values: anObject [
	values := anObject
]
