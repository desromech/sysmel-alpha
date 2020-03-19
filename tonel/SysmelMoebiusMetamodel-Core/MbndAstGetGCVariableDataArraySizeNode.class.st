Class {
	#name : #MbndAstGetGCVariableDataArraySizeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'container'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGetGCVariableDataArraySizeNode >> accept: visitor [
	^ visitor visitGetGCVariableDataArraySizeNode: self
]

{ #category : #accessing }
MbndAstGetGCVariableDataArraySizeNode >> container [
	^ container
]

{ #category : #accessing }
MbndAstGetGCVariableDataArraySizeNode >> container: anObject [
	container := anObject
]

{ #category : #serialization }
MbndAstGetGCVariableDataArraySizeNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#container . container encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstGetGCVariableDataArraySizeNode >> isGetGCVariableDataArraySizeNode [
	^ true
]

{ #category : #serialization }
MbndAstGetGCVariableDataArraySizeNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	container := encodedFields at: #container.
]
