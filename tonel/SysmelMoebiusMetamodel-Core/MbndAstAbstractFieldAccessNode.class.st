Class {
	#name : #MbndAstAbstractFieldAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'aggregate',
		'field'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> aggregate [
	^ aggregate
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> aggregate: anObject [
	aggregate := anObject
]

{ #category : #serialization }
MbndAstAbstractFieldAccessNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#aggregate . aggregate encodeGraphForMessagePackWith: graphEncoder.
		#field . field encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> field [
	^ field
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> field: anObject [
	field := anObject
]

{ #category : #serialization }
MbndAstAbstractFieldAccessNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	aggregate := encodedFields at: #aggregate.
	field := encodedFields at: #field.
]
