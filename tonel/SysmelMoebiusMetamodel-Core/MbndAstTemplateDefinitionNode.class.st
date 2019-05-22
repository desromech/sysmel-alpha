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

{ #category : #testing }
MbndAstTemplateDefinitionNode >> isTemplateDefinitionNode [
	^ true
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
