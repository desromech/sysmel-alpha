Class {
	#name : #MbndAstAbstractVectorAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'vector',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstAbstractVectorAccessNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#vector . vector encodeGraphForMessagePackWith: graphEncoder.
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #serialization }
MbndAstAbstractVectorAccessNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	vector := encodedFields at: #vector.
	elements := encodedFields at: #elements.
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> vector [
	^ vector
]

{ #category : #accessing }
MbndAstAbstractVectorAccessNode >> vector: anObject [
	vector := anObject
]
