Class {
	#name : #MbndAstImmediateBlockClosureActivationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'blockNode',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstImmediateBlockClosureActivationNode >> accept: visitor [
	^ visitor visitImmediateBlockClosureActivationNode: self
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> blockNode [
	^ blockNode
]

{ #category : #accessing }
MbndAstImmediateBlockClosureActivationNode >> blockNode: anObject [
	blockNode := anObject
]

{ #category : #serialization }
MbndAstImmediateBlockClosureActivationNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#blockNode . blockNode encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstImmediateBlockClosureActivationNode >> isImmediateBlockClosureActivationNode [
	^ true
]

{ #category : #serialization }
MbndAstImmediateBlockClosureActivationNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	blockNode := encodedFields at: #blockNode.
	arguments := encodedFields at: #arguments.
]
