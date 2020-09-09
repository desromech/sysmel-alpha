Class {
	#name : #MbndAstAbstractTypeDefinitionNode,
	#superclass : #MbndAstAbstractProgramEntityDefinitionNode,
	#instVars : [
		'body',
		'poolDictionaries',
		'usedTraits'
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
		#poolDictionaries . poolDictionaries encodeGraphForMessagePackWith: graphEncoder.
		#usedTraits . usedTraits encodeGraphForMessagePackWith: graphEncoder.
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
	poolDictionaries := encodedFields at: #poolDictionaries.
	usedTraits := encodedFields at: #usedTraits.
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> poolDictionaries [
	^ poolDictionaries
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> poolDictionaries: anObject [
	poolDictionaries := anObject
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode [
	^ nil
]

{ #category : #'as yet unclassified' }
MbndAstAbstractTypeDefinitionNode >> superTypeNode: aNode [
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> usedTraits [
	^ usedTraits
]

{ #category : #accessing }
MbndAstAbstractTypeDefinitionNode >> usedTraits: anObject [
	usedTraits := anObject
]
