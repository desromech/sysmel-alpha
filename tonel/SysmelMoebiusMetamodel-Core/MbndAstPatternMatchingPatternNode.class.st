Class {
	#name : #MbndAstPatternMatchingPatternNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'matchedType',
		'matchedValue',
		'testingExpression'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #converting }
MbndAstPatternMatchingPatternNode >> asNeverPatternNode [
	^ MbndAstPatternMatchingNeverPatternNode new
		position: self;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingPatternNode >> collectBindings [
	^ Array streamContents: [ :out |
		self collectBindingsInto: out
	]
]

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingPatternNode >> collectBindingsInto: out [
	"Nothing required by default"
]

{ #category : #serialization }
MbndAstPatternMatchingPatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#matchedType . matchedType encodeGraphForMessagePackWith: graphEncoder.
		#matchedValue . matchedValue encodeGraphForMessagePackWith: graphEncoder.
		#testingExpression . testingExpression encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPatternMatchingPatternNode >> isDefaultPattern [
	^ false
]

{ #category : #testing }
MbndAstPatternMatchingPatternNode >> isNeverPattern [
	^ false
]

{ #category : #testing }
MbndAstPatternMatchingPatternNode >> isPatternMatchingPatternNode [
	^ true
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> matchedType [
	^ matchedType
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> matchedType: anObject [
	matchedType := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> matchedValue [
	^ matchedValue
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> matchedValue: anObject [
	matchedValue := anObject
]

{ #category : #serialization }
MbndAstPatternMatchingPatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	matchedType := encodedFields at: #matchedType.
	matchedValue := matchedValue encodeGraphForMessagePackWith: #matchedType.
	testingExpression := encodedFields at: #testingExpression.
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> testingExpression [
	^ testingExpression
]

{ #category : #accessing }
MbndAstPatternMatchingPatternNode >> testingExpression: anObject [
	testingExpression := anObject
]
