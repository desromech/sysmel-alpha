Class {
	#name : #MbndAstPatternMatchingSameValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'expectedValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingSameValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingSameValuePatternNode: self
]

{ #category : #converting }
MbndAstPatternMatchingSameValuePatternNode >> asSameValuePatternNode [
	^ self
]

{ #category : #serialization }
MbndAstPatternMatchingSameValuePatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expectedValue . expectedValue encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstPatternMatchingSameValuePatternNode >> expectedValue [
	^ expectedValue
]

{ #category : #accessing }
MbndAstPatternMatchingSameValuePatternNode >> expectedValue: anObject [
	expectedValue := anObject
]

{ #category : #testing }
MbndAstPatternMatchingSameValuePatternNode >> isPatternMatchingSameValuePatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingSameValuePatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expectedValue := encodedFields at: #expectedValue.
]
