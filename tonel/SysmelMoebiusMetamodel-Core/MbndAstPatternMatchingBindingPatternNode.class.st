Class {
	#name : #MbndAstPatternMatchingBindingPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'name',
		'valuePattern',
		'requiredType',
		'binding',
		'initialValueKind'
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
	valuePattern ifNotNil: [ valuePattern collectBindingsInto: out ]
]

{ #category : #serialization }
MbndAstPatternMatchingBindingPatternNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name encodeGraphForMessagePackWith: graphEncoder.
		#valuePattern . valuePattern encodeGraphForMessagePackWith: graphEncoder.
		#binding . binding encodeGraphForMessagePackWith: graphEncoder.
		#initialValueKind . initialValueKind.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> initialValueKind [
	^ initialValueKind
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> initialValueKind: anObject [
	initialValueKind := anObject
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isDefaultPattern [
	^ valuePattern isNil
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isPatternMatchingBindingPatternNode [
	^ true
]

{ #category : #serialization }
MbndAstPatternMatchingBindingPatternNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	name := encodedFields at: #name.
	valuePattern := encodedFields at: #valuePattern.
	binding := encodedFields at: #binding.
	initialValueKind := encodedFields at: #initialValueKind.
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
MbndAstPatternMatchingBindingPatternNode >> requiredType [
	^ requiredType
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> requiredType: anObject [
	requiredType := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> valuePattern [
	^ valuePattern
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> valuePattern: anObject [
	valuePattern := anObject
]
