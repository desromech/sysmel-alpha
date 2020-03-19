Class {
	#name : #MbndAstSpliceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSpliceNode >> accept: aVisitor [
	^ aVisitor visitSpliceNode: self
]

{ #category : #serialization }
MbndAstSpliceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstSpliceNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstSpliceNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstSpliceNode >> isSpliceNode [
	^ true
]

{ #category : #serialization }
MbndAstSpliceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
]
