Class {
	#name : #MbndAstReferenceAsPointerNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReferenceAsPointerNode >> accept: aVisitor [
	^ aVisitor visitReferenceAsPointerNode: self
]

{ #category : #serialization }
MbndAstReferenceAsPointerNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#reference . reference encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstReferenceAsPointerNode >> isReferenceAsPointerNode [
	^ true
]

{ #category : #serialization }
MbndAstReferenceAsPointerNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	reference := encodedFields at: #reference.
]

{ #category : #accessing }
MbndAstReferenceAsPointerNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstReferenceAsPointerNode >> reference: anObject [
	reference := anObject
]
