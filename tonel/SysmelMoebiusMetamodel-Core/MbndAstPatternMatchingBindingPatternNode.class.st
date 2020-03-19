Class {
	#name : #MbndAstPatternMatchingBindingPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'name',
		'value',
		'binding'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingBindingPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingBindingPatternNode: self
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> binding: anObject [
	binding := anObject
]

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingBindingPatternNode >> collectBindingsInto: out [
	out nextPut: self.
	value ifNotNil: [ value collectBindingsInto: out ]
]

{ #category : #serialization }
MbndAstPatternMatchingBindingPatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name encodeGraphForMessagePackWith: graphEncoder.
		#value . value encodeGraphForMessagePackWith: graphEncoder.
		#binding . binding encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isDefaultPattern [
	^ value isNil
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isPatternMatchingBindingPatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingBindingPatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	name := encodedFields at: #name.
	value := encodedFields at: #value.
	binding := encodedFields at: #binding.
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> name [
	^ name
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> value: anObject [
	value := anObject
]
