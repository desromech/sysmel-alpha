Class {
	#name : #MbndAstPatternMatchingSetValuePatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingSetValuePatternNode >> accept: visitor [
	^ visitor visitPatternMatchingSetPatternNode: self
]

{ #category : #accessing }
MbndAstPatternMatchingSetValuePatternNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstPatternMatchingSetValuePatternNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstPatternMatchingSetValuePatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPatternMatchingSetValuePatternNode >> isPatternMatchingLiteralValueSetPatternNode [
	^ true
]

{ #category : #testing }
MbndAstPatternMatchingSetValuePatternNode >> isPatternMatchingSetValuePatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingSetValuePatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	elements := encodedFields at: #elements.

]
