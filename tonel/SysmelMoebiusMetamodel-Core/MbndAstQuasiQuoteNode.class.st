Class {
	#name : #MbndAstQuasiQuoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuasiQuoteNode >> accept: aVisitor [
	^ aVisitor visitQuasiQuoteNode: self
]

{ #category : #serialization }
MbndAstQuasiQuoteNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstQuasiQuoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuasiQuoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuasiQuoteNode >> isQuasiQuoteNode [
	^ true
]

{ #category : #serialization }
MbndAstQuasiQuoteNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
]
