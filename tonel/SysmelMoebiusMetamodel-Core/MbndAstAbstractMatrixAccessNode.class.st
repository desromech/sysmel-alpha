Class {
	#name : #MbndAstAbstractMatrixAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matrix',
		'element'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> element [
	^ element
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> element: anObject [
	element := anObject
]

{ #category : #serialization }
MbndAstAbstractMatrixAccessNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#matrix . matrix encodeGraphForMessagePackWith: graphEncoder.
		#element . element encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndAstAbstractMatrixAccessNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	matrix := encodedFields at: #matrix.
	element := encodedFields at: #element.
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> matrix [
	^ matrix
]

{ #category : #accessing }
MbndAstAbstractMatrixAccessNode >> matrix: anObject [
	matrix := anObject
]
