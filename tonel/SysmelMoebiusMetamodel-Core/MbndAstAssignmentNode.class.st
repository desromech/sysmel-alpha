Class {
	#name : #MbndAstAssignmentNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstAssignmentNode >> accept: aVisitor [
	^ aVisitor visitAssignmentNode: self
]

{ #category : #serialization }
MbndAstAssignmentNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#reference . reference encodeGraphForMessagePackWith: graphEncoder.
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstAssignmentNode >> isAssignmentNode [
	^ true
]

{ #category : #serialization }
MbndAstAssignmentNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	reference := encodedFields at: #reference.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstAssignmentNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstAssignmentNode >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
MbndAstAssignmentNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstAssignmentNode >> value: anObject [
	value := anObject
]
