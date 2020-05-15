Class {
	#name : #MbndAstAggregateConstructionNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'aggregate',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAggregateConstructionNode >> aggregate [
	^ aggregate
]

{ #category : #accessing }
MbndAstAggregateConstructionNode >> aggregate: anObject [
	aggregate := anObject
]

{ #category : #accessing }
MbndAstAggregateConstructionNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstAggregateConstructionNode >> elements: anObject [
	elements := anObject
]

{ #category : #serialization }
MbndAstAggregateConstructionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#aggregate . aggregate encodeGraphForMessagePackWith: graphEncoder.
		#elements . elements encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstAggregateConstructionNode >> isAggregateConstructionNode [
	^ true
]

{ #category : #serialization }
MbndAstAggregateConstructionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	aggregate := encodedFields at: #aggregate.
	elements := encodedFields at: #elements.
]
