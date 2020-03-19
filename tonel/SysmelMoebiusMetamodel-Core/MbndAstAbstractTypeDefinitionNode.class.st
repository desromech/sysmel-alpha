Class {
	#name : #MbndAstAbstractTypeDefinitionNode,
	#superclass : #MbndAstAbstractProgramEntityDefinitionNode,
	#instVars : [
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> body: anObject [
	body := anObject
]

{ #category : #serialization }
MbndAstAbstractTypeDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#body . body encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> inferTemplateKindWithCompilationTarget: compilationTarget [
	^ compilationTarget typeTemplateType
]

{ #category : #testing }
MbndAstAbstractTypeDefinitionNode >> isAbstractTypeDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstAbstractTypeDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	body := encodedFields at: #body.
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode [
	^ nil
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode: aNode [
]
