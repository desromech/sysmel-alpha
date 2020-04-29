Class {
	#name : #MbndAstCopyIntoTemporaryVariableNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'value',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCopyIntoTemporaryVariableNode >> accept: aVisitor [
	^ aVisitor visitCopyIntoTemporaryVariableNode: self
]

{ #category : #serialization }
MbndAstCopyIntoTemporaryVariableNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstCopyIntoTemporaryVariableNode >> isCopyIntoTemporaryVariableNode [
	^ true
]

{ #category : #visiting }
MbndAstCopyIntoTemporaryVariableNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstCopyIntoTemporaryVariableNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> value: anObject [
	value := anObject
]
