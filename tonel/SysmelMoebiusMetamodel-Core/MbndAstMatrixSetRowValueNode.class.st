Class {
	#name : #MbndAstMatrixSetRowValueNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixSetRowValueNode >> accept: visitor [
	^ visitor visitMatrixSetRowValueNode: self
]

{ #category : #serialization }
MbndAstMatrixSetRowValueNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMatrixSetRowValueNode >> isMatrixSetRowValueNode [
	^ true
]

{ #category : #serialization }
MbndAstMatrixSetRowValueNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstMatrixSetRowValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstMatrixSetRowValueNode >> value: anObject [
	value := anObject
]
