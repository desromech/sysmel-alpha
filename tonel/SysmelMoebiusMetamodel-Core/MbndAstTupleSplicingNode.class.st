Class {
	#name : #MbndAstTupleSplicingNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'tupleExpression',
		'elementIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstTupleSplicingNode >> accept: visitor [
	^ visitor visitTupleSplicingNode: self
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> elementIndex [
	^ elementIndex
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> elementIndex: anObject [
	elementIndex := anObject
]

{ #category : #serialization }
MbndAstTupleSplicingNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#tupleExpression . tupleExpression encodeGraphForMessagePackWith: graphEncoder.
		#elementIndex . elementIndex encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstTupleSplicingNode >> isTupleSplicingNode [
	^ true
]

{ #category : #serialization }
MbndAstTupleSplicingNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	tupleExpression := encodedFields at: #tupleExpression.
	elementIndex := encodedFields at: #elementIndex.
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> tupleExpression [
	^ tupleExpression
]

{ #category : #accessing }
MbndAstTupleSplicingNode >> tupleExpression: anObject [
	tupleExpression := anObject
]
