Class {
	#name : #MbndAstCasesOfCaseNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'patternValueType',
		'pattern',
		'bindings',
		'action'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCasesOfCaseNode >> accept: aVisitor [
	^ aVisitor visitCasesOfCaseNode: self
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> action [
	^ action
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> action: anObject [
	action := anObject
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> bindings [
	^ bindings
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> bindings: anObject [
	bindings := anObject
]

{ #category : #serialization }
MbndAstCasesOfCaseNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#patternValueType . patternValueType encodeGraphForMessagePackWith: graphEncoder.
		#pattern . pattern encodeGraphForMessagePackWith: graphEncoder.
		#bindings . bindings encodeGraphForMessagePackWith: graphEncoder.
		#action . action encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstCasesOfCaseNode >> hasDefaultPattern [
	^ pattern isDefaultPattern
]

{ #category : #testing }
MbndAstCasesOfCaseNode >> isCasesOfCaseNode [
	^ true
]

{ #category : #serialization }
MbndAstCasesOfCaseNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	patternValueType := encodedFields at: #patternValueType.
	pattern := encodedFields at: #pattern.
	bindings := encodedFields at: #bindings.
	action := encodedFields at: #action.
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> pattern [
	^ pattern
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> pattern: anObject [
	pattern := anObject
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> patternValueType [
	^ patternValueType
]

{ #category : #accessing }
MbndAstCasesOfCaseNode >> patternValueType: anObject [
	patternValueType := anObject
]
