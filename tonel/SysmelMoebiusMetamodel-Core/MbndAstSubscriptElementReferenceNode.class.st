Class {
	#name : #MbndAstSubscriptElementReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'container',
		'index',
		'isOneBasedIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> container [
	^ container
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> container: anObject [
	container := anObject
]

{ #category : #serialization }
MbndAstSubscriptElementReferenceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#container . container encodeGraphForMessagePackWith: graphEncoder.
		#index. index encodeGraphForMessagePackWith: graphEncoder.
		#isOneBasedIndex. isOneBasedIndex.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> index [
	^ index
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> index: anObject [
	index := anObject
]

{ #category : #initialization }
MbndAstSubscriptElementReferenceNode >> initialize [
	super initialize.
	isOneBasedIndex := false.
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> isOneBasedIndex [
	^ isOneBasedIndex
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> isOneBasedIndex: anObject [
	isOneBasedIndex := anObject
]

{ #category : #testing }
MbndAstSubscriptElementReferenceNode >> isSubscriptElementReferenceNode [
	^ true
]

{ #category : #serialization }
MbndAstSubscriptElementReferenceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	container := encodedFields at: #container.
	index := encodedFields at: #index.
	isOneBasedIndex := encodedFields at: #isOneBasedIndex.
]
