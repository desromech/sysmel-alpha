Class {
	#name : #MbndAstPointerAsReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'pointer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPointerAsReferenceNode >> accept: aVisitor [
	^ aVisitor visitPointerAsReferenceNode: self
]

{ #category : #serialization }
MbndAstPointerAsReferenceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#pointer . pointer encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPointerAsReferenceNode >> isPointerAsReferenceNode [
	^ true
]

{ #category : #serialization }
MbndAstPointerAsReferenceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	pointer := encodedFields at: #pointer.
]

{ #category : #accessing }
MbndAstPointerAsReferenceNode >> pointer [
	^ pointer
]

{ #category : #accessing }
MbndAstPointerAsReferenceNode >> pointer: anObject [
	pointer := anObject
]
