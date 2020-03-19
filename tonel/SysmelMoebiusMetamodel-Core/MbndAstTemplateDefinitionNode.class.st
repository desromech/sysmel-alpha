Class {
	#name : #MbndAstTemplateDefinitionNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'name',
		'arguments',
		'body',
		'ownerProgramEntity',
		'binding'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstTemplateDefinitionNode >> accept: aVisitor [
	^ aVisitor visitTemplateDefinitionNode: self
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> body: anObject [
	body := anObject
]

{ #category : #serialization }
MbndAstTemplateDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#flags . flags.
		#name . name encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#body . body encodeGraphForMessagePackWith: graphEncoder.
		#ownerProgramEntity . ownerProgramEntity encodeGraphForMessagePackWith: graphEncoder.
		#binding . binding encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstTemplateDefinitionNode >> isTemplateDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstTemplateDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	flags := encodedFields at: #flags.
	name := encodedFields at: #name.
	arguments := encodedFields at: #arguments.
	body := encodedFields at: #body.
	ownerProgramEntity := encodedFields at: #ownerProgra
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> name [
	^ name
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstTemplateDefinitionNode >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]
