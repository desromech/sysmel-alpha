Class {
	#name : #MbndAstFunctionCallNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'function',
		'arguments',
		'functionReturnType',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstFunctionCallNode >> accept: aVisitor [
	^ aVisitor visitFunctionCallNode: self
]

{ #category : #accessing }
MbndAstFunctionCallNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstFunctionCallNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #serialization }
MbndAstFunctionCallNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#function . function encodeGraphForMessagePackWith: graphEncoder.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#functionReturnType . functionReturnType encodeGraphForMessagePackWith: graphEncoder.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstFunctionCallNode >> function [
	^ function
]

{ #category : #accessing }
MbndAstFunctionCallNode >> function: anObject [
	function := anObject
]

{ #category : #accessing }
MbndAstFunctionCallNode >> functionReturnType [
	^ functionReturnType
]

{ #category : #accessing }
MbndAstFunctionCallNode >> functionReturnType: anObject [
	functionReturnType := anObject
]

{ #category : #testing }
MbndAstFunctionCallNode >> isFunctionCallNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstFunctionCallNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	functionReturnType ifNil: [ ^ self ].
	functionReturnType isMemoryReturnedType ifTrue: [
		storageCreationNode := aStorageCreationNode
	].

]

{ #category : #serialization }
MbndAstFunctionCallNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	function := encodedFields at: #function.
	arguments := encodedFields at: #arguments.
	functionReturnType := encodedFields at: #functionReturnType.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstFunctionCallNode >> storageCreationNode [
	^ storageCreationNode
]
