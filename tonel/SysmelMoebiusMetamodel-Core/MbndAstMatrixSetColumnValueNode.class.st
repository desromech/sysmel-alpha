Class {
	#name : #MbndAstMatrixSetColumnValueNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixSetColumnValueNode >> accept: visitor [
	^ visitor visitMatrixSetColumnValueNode: self
]

{ #category : #serialization }
MbndAstMatrixSetColumnValueNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstMatrixSetColumnValueNode >> isMatrixSetColumnValueNode [
	^ true
]

{ #category : #serialization }
MbndAstMatrixSetColumnValueNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstMatrixSetColumnValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstMatrixSetColumnValueNode >> value: anObject [
	value := anObject
]
