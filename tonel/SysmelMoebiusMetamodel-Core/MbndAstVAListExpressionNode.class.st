Class {
	#name : #MbndAstVAListExpressionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'valist'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #serialization }
MbndAstVAListExpressionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#valist . valist encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstVAListExpressionNode >> isVAListExpressionNode [
	^ true
]

{ #category : #serialization }
MbndAstVAListExpressionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	valist := encodedFields at: #valist.
]

{ #category : #accessing }
MbndAstVAListExpressionNode >> valist [
	^ valist
]

{ #category : #accessing }
MbndAstVAListExpressionNode >> valist: anObject [
	valist := anObject
]
