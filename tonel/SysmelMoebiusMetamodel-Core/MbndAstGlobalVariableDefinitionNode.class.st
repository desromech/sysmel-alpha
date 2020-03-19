Class {
	#name : #MbndAstGlobalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'constructionPriority'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGlobalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitGlobalVariableDefinitionNode: self
]

{ #category : #accessing }
MbndAstGlobalVariableDefinitionNode >> constructionPriority [
	^ constructionPriority
]

{ #category : #accessing }
MbndAstGlobalVariableDefinitionNode >> constructionPriority: anObject [
	constructionPriority := anObject
]

{ #category : #serialization }
MbndAstGlobalVariableDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#constructionPriority . constructionPriority encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstGlobalVariableDefinitionNode >> isGlobalVariableDefinitionNode [
	^ true
]

{ #category : #serialization }
MbndAstGlobalVariableDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	constructionPriority := encodedFields at: #constructionPriority.
]
