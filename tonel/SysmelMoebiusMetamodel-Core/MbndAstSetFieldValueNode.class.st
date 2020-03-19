Class {
	#name : #MbndAstSetFieldValueNode,
	#superclass : #MbndAstAbstractFieldAccessNode,
	#instVars : [
		'newValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSetFieldValueNode >> accept: aVisitor [
	^ aVisitor visitSetFieldValueNode: self
]

{ #category : #serialization }
MbndAstSetFieldValueNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#newValue . newValue encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstSetFieldValueNode >> isSetFieldValueNode [
	^ true
]

{ #category : #serialization }
MbndAstSetFieldValueNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	newValue := encodedFields at: #newValue.
]

{ #category : #accessing }
MbndAstSetFieldValueNode >> newValue [
	^ newValue
]

{ #category : #accessing }
MbndAstSetFieldValueNode >> newValue: anObject [
	newValue := anObject
]
