Class {
	#name : #MbndAstPragmaNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPragmaNode >> accept: aVisitor [
	^ aVisitor visitPragmaNode: self
]

{ #category : #accessing }
MbndAstPragmaNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstPragmaNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #serialization }
MbndAstPragmaNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#selector . selector encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstPragmaNode >> isPragmaNode [
	^ true
]

{ #category : #serialization }
MbndAstPragmaNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	selector := encodedFields at: #selector.
	arguments := encodedFields at: #arguments.
]

{ #category : #accessing }
MbndAstPragmaNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstPragmaNode >> selector: anObject [
	selector := anObject
]
