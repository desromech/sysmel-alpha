Class {
	#name : #MbndAstPatternMatchingLiteralValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingLiteralValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingLiteralValuePatternNode: self
]

{ #category : #serialization }
MbndAstPatternMatchingLiteralValuePatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPatternMatchingLiteralValuePatternNode >> isPatternMatchingLiteralValuePatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingLiteralValuePatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingLiteralValuePatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstPatternMatchingLiteralValuePatternNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstPatternMatchingLiteralValuePatternNode >> value: anObject [
	value := anObject
]
