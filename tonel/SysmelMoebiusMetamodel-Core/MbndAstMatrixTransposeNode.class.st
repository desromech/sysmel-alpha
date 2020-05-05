Class {
	#name : #MbndAstMatrixTransposeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matrix'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixTransposeNode >> accept: visitor [
	^ visitor visitMatrixTransposeNode: self
]

{ #category : #serialization }
MbndAstMatrixTransposeNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#matrix . matrix encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMatrixTransposeNode >> isMatrixTransposeNode [
	^ true
]

{ #category : #serialization }
MbndAstMatrixTransposeNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	matrix := encodedFields at: #matrix.
]

{ #category : #accessing }
MbndAstMatrixTransposeNode >> matrix [
	^ matrix
]

{ #category : #accessing }
MbndAstMatrixTransposeNode >> matrix: anObject [
	matrix := anObject
]
