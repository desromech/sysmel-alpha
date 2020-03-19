Class {
	#name : #MbndAstQuasiUnquoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuasiUnquoteNode >> accept: aVisitor [
	^ aVisitor visitQuasiUnquoteNode: self
]

{ #category : #serialization }
MbndAstQuasiUnquoteNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstQuasiUnquoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuasiUnquoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuasiUnquoteNode >> isQuasiUnquoteNode [
	^ true
]

{ #category : #serialization }
MbndAstQuasiUnquoteNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
]
