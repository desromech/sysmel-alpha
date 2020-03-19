Class {
	#name : #MbndAstMatrixMultiplicationOperationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'leftMatrix',
		'rightMatrix'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixMultiplicationOperationNode >> accept: visitor [
	^ visitor visitMatrixMultiplicationOperationNode: self
]

{ #category : #serialization }
MbndAstMatrixMultiplicationOperationNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#leftMatrix . leftMatrix encodeGraphForMessagePackWith: graphEncoder.
		#rightMatrix . rightMatrix encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMatrixMultiplicationOperationNode >> isMatrixMultiplicationOperationNode [
	^ true
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> leftMatrix [
	^ leftMatrix
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> leftMatrix: anObject [
	leftMatrix := anObject
]

{ #category : #serialization }
MbndAstMatrixMultiplicationOperationNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	leftMatrix := encodedFields at: #leftMatrix.
	rightMatrix := encodedFields at: #rightMatrix.
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> rightMatrix [
	^ rightMatrix
]

{ #category : #accessing }
MbndAstMatrixMultiplicationOperationNode >> rightMatrix: anObject [
	rightMatrix := anObject
]
