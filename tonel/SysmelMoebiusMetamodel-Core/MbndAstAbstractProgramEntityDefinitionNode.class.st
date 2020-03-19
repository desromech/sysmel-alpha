Class {
	#name : #MbndAstAbstractProgramEntityDefinitionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'declaration'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractProgramEntityDefinitionNode >> binding [
	^ declaration binding
]

{ #category : #accessing }
MbndAstAbstractProgramEntityDefinitionNode >> declaration [
	^ declaration
]

{ #category : #accessing }
MbndAstAbstractProgramEntityDefinitionNode >> declaration: anObject [
	declaration := anObject
]

{ #category : #serialization }
MbndAstAbstractProgramEntityDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#declaration . declaration encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndAstAbstractProgramEntityDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	declaration := encodedFields at: #declaration
]
