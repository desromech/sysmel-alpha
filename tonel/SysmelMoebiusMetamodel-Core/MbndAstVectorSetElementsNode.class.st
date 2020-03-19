Class {
	#name : #MbndAstVectorSetElementsNode,
	#superclass : #MbndAstAbstractVectorAccessNode,
	#instVars : [
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVectorSetElementsNode >> accept: visitor [
	^ visitor visitVectorSetElementsNode: self
]

{ #category : #serialization }
MbndAstVectorSetElementsNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#values . values encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstVectorSetElementsNode >> isVectorSetElementsNode [
	^ true
]

{ #category : #serialization }
MbndAstVectorSetElementsNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	values := encodedFields at: #values.
]

{ #category : #accessing }
MbndAstVectorSetElementsNode >> values [
	^ values
]

{ #category : #accessing }
MbndAstVectorSetElementsNode >> values: anObject [
	values := anObject
]
