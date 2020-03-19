Class {
	#name : #MbndAstVectorConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'vectorType',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstVectorConstructionNode >> accept: visitor [
	^ visitor visitVectorConstructionNode: self
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstVectorConstructionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#vectorType . vectorType encodeGraphForMessagePackWith: graphEncoder.
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstVectorConstructionNode >> isVectorConstructionNode [
	^ true
]

{ #category : #serialization }
MbndAstVectorConstructionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	vectorType := encodedFields at: #vectorType.
	elements := encodedFields at: #elements.
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> vectorType [
	^ vectorType
]

{ #category : #accessing }
MbndAstVectorConstructionNode >> vectorType: anObject [
	vectorType := anObject
]
