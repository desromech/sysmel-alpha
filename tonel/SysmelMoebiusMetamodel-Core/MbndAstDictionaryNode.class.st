Class {
	#name : #MbndAstDictionaryNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDictionaryNode >> accept: visitor [
	^ visitor visitDictionaryNode: self
]

{ #category : #accessing }
MbndAstDictionaryNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstDictionaryNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstDictionaryNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #visiting }
MbndAstDictionaryNode >> isDictionaryNode [
	^ true
]

{ #category : #serialization }
MbndAstDictionaryNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	elements := encodedFields at: #elements.
]
