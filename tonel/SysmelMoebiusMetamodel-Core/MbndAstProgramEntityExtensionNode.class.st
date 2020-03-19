Class {
	#name : #MbndAstProgramEntityExtensionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'programEntity',
		'body'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstProgramEntityExtensionNode >> accept: visitor [
	^ visitor visitProgramEntityExtensionNode: self
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> body: anObject [
	body := anObject
]

{ #category : #serialization }
MbndAstProgramEntityExtensionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#programEntity . programEntity encodeGraphForMessagePackWith: graphEncoder.
		#body . body encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstProgramEntityExtensionNode >> isProgramEntityExtensionNode [
	^ true
]

{ #category : #serialization }
MbndAstProgramEntityExtensionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	programEntity := encodedFields at: #programEntity.
	body := encodedFields at: #body.
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndAstProgramEntityExtensionNode >> programEntity: anObject [
	programEntity := anObject
]
