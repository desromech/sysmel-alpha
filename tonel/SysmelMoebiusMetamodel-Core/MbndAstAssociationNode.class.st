Class {
	#name : #MbndAstAssociationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstAssociationNode >> accept: visitor [
	^ visitor visitAssociationNode: self
]

{ #category : #serialization }
MbndAstAssociationNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#key . key encodeGraphForMessagePackWith: graphEncoder.
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstAssociationNode >> isAssociationNode [
	^ true
]

{ #category : #accessing }
MbndAstAssociationNode >> key [
	^ key
]

{ #category : #accessing }
MbndAstAssociationNode >> key: anObject [
	key := anObject
]

{ #category : #serialization }
MbndAstAssociationNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	key := encodedFields at: #key.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstAssociationNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstAssociationNode >> value: anObject [
	value := anObject
]
