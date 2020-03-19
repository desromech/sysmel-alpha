Class {
	#name : #MbndAstAbstractClassDefinitionNode,
	#superclass : #MbndAstAbstractTypeDefinitionNode,
	#instVars : [
		'superclass'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #serialization }
MbndAstAbstractClassDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#superclass . superclass encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndAstAbstractClassDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	superclass := encodedFields at: #superclass.
]

{ #category : #'as yet unclassified' }
MbndAstAbstractClassDefinitionNode >> superTypeNode [
	^ self superclass
]

{ #category : #'as yet unclassified' }
MbndAstAbstractClassDefinitionNode >> superTypeNode: aNode [
	self superclass: aNode
]

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass [
	^ superclass
]

{ #category : #accessing }
MbndAstAbstractClassDefinitionNode >> superclass: anObject [
	superclass := anObject
]
