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

{ #category : #accessing }
MbndAstFunctionCallNode >> storageCreationNode [
	^ storageCreationNode
]
