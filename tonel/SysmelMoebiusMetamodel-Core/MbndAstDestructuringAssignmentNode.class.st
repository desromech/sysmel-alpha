Class {
	#name : #MbndAstDestructuringAssignmentNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'bindings',
		'pattern',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDestructuringAssignmentNode >> accept: aVisitor [
	^ aVisitor visitDestructuringAssignmentNode: self
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> bindings [
	^ bindings
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> bindings: anObject [
	bindings := anObject
]

{ #category : #serialization }
MbndAstDestructuringAssignmentNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#pattern . pattern encodeGraphForMessagePackWith: graphEncoder.
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstDestructuringAssignmentNode >> hasDefaultPattern [
	^ pattern isDefaultPattern
]

{ #category : #visiting }
MbndAstDestructuringAssignmentNode >> isDestructuringAssignmentNode [
	^ true
]

{ #category : #serialization }
MbndAstDestructuringAssignmentNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	pattern := encodedFields at: #pattern.
	value := encodedFields at: #value.
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> pattern [
	^ pattern
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> pattern: anObject [
	pattern := anObject
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstDestructuringAssignmentNode >> value: anObject [
	value := anObject
]
