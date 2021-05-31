Class {
	#name : #MbndAstCopyIntoTemporaryVariableNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'value',
		'storageCreationNode',
		'avoidCopy'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCopyIntoTemporaryVariableNode >> accept: aVisitor [
	^ aVisitor visitCopyIntoTemporaryVariableNode: self
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> avoidCopy [

	^ avoidCopy
]

{ #category : #accessing }
MbndAstCopyIntoTemporaryVariableNode >> avoidCopy: anObject [

	avoidCopy := anObject
]

{ #category : #serialization }
MbndAstCopyIntoTemporaryVariableNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
		#avoidCopy . avoidCopy.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #initialization }
MbndAstCopyIntoTemporaryVariableNode >> initialize [
	super initialize.
	avoidCopy := false.
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
	avoidCopy := encodedFields at: #avoidCopy.
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
