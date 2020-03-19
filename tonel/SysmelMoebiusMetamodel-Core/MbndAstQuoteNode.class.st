Class {
	#name : #MbndAstQuoteNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstQuoteNode >> accept: aVisitor [
	^ aVisitor visitQuoteNode: self
]

{ #category : #serialization }
MbndAstQuoteNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstQuoteNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstQuoteNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstQuoteNode >> isQuoteNode [
	^ true
]

{ #category : #serialization }
MbndAstQuoteNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
]
