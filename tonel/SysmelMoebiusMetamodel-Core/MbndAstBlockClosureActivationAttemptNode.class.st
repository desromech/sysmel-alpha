Class {
	#name : #MbndAstBlockClosureActivationAttemptNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'blockNode',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBlockClosureActivationAttemptNode >> accept: visitor [
	^ visitor visitBlockClosureActivationAttemptNode: self
]

{ #category : #accessing }
MbndAstBlockClosureActivationAttemptNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstBlockClosureActivationAttemptNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
MbndAstBlockClosureActivationAttemptNode >> blockNode [
	^ blockNode
]

{ #category : #accessing }
MbndAstBlockClosureActivationAttemptNode >> blockNode: anObject [
	blockNode := anObject
]

{ #category : #serialization }
MbndAstBlockClosureActivationAttemptNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#blockNode . blockNode.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstBlockClosureActivationAttemptNode >> isBlockClosureActivationAttemptNode [
	^ true
]

{ #category : #serialization }
MbndAstBlockClosureActivationAttemptNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	blockNode := encodedFields at: #blockNode.
	arguments := encodedFields at: #arguments.
]
