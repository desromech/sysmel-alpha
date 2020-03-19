Class {
	#name : #MbndAstCaughtExceptionReferenceNode,
	#superclass : #MbndAstSymbolReference,
	#instVars : [
		'catchExpressionNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCaughtExceptionReferenceNode >> accept: aVisitor [
	^ aVisitor visitCaughtExceptionReferenceNode: self
]

{ #category : #accessing }
MbndAstCaughtExceptionReferenceNode >> catchExpressionNode [
	^ catchExpressionNode
]

{ #category : #accessing }
MbndAstCaughtExceptionReferenceNode >> catchExpressionNode: anObject [
	catchExpressionNode := anObject
]

{ #category : #serialization }
MbndAstCaughtExceptionReferenceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#catchExpressionNode . catchExpressionNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstCaughtExceptionReferenceNode >> isCaughtExceptionReferenceNode [
	^ true
]

{ #category : #serialization }
MbndAstCaughtExceptionReferenceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	catchExpressionNode := encodedFields at: #catchExpressionNode.
]
