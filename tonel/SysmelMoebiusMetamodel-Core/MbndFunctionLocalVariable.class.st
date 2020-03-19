Class {
	#name : #MbndFunctionLocalVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionLocalVariable class >> messagePackTypeName [
	^ #FunctionLocalVariable
]

{ #category : #visiting }
MbndFunctionLocalVariable >> accept: visitor [
	^ visitor visitFunctionLocalVariable: self
]

{ #category : #serialization }
MbndFunctionLocalVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#type . type encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #testing }
MbndFunctionLocalVariable >> isFunctionLocalVariable [
	^ true
]

{ #category : #serialization }
MbndFunctionLocalVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	type := encodedFields at: #type.
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type: aType [
	type := aType
]
