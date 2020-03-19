Class {
	#name : #MbndAstMatrixConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matrixType',
		'columns'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixConstructionNode >> accept: visitor [
	^ visitor visitMatrixConstructionNode: self
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> columns [
	^ columns
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> columns: anObject [
	columns := anObject
]

{ #category : #serialization }
MbndAstMatrixConstructionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#matrixType . matrixType encodeGraphForMessagePackWith: graphEncoder.
		#columns . columns encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMatrixConstructionNode >> isMatrixConstructionNode [
	^ true
]

{ #category : #serialization }
MbndAstMatrixConstructionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	matrixType := encodedFields at: #matrixType.
	columns := encodedFields at: #columns.
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> matrixType [
	^ matrixType
]

{ #category : #accessing }
MbndAstMatrixConstructionNode >> matrixType: anObject [
	matrixType := anObject
]
