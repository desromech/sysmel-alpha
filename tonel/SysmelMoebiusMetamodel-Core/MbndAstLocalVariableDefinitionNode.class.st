Class {
	#name : #MbndAstLocalVariableDefinitionNode,
	#superclass : #MbndAstAbstractVariableDefinitionNode,
	#instVars : [
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLocalVariableDefinitionNode >> accept: aVisitor [
	^ aVisitor visitLocalVariableDefinitionNode: self
]

{ #category : #serialization }
MbndAstLocalVariableDefinitionNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstLocalVariableDefinitionNode >> isLocalVariableDefinitionNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstLocalVariableDefinitionNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	self assert: type isNotNil.
	valueType isTemporaryReferenceType ifTrue: [ ^ initialValue markStorageCreationNodeForCopyEllision: aStorageCreationNode ].
	valueType isTypePassedByReference ifTrue: [
		storageCreationNode := aStorageCreationNode
	].
]

{ #category : #serialization }
MbndAstLocalVariableDefinitionNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstLocalVariableDefinitionNode >> storageCreationNode [
	^ storageCreationNode
]
