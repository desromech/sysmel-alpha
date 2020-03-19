Class {
	#name : #MbndAstTemporaryVariableNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'valueType',
		'hasBasicInitialization',
		'hasInitialization',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstTemporaryVariableNode >> accept: visitor [
	^ visitor visitTemporaryVariableNode: self
]

{ #category : #serialization }
MbndAstTemporaryVariableNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#valueType . valueType encodeGraphForMessagePackWith: graphEncoder.
		#hasBasicInitialization . hasBasicInitialization.
		#hasInitialization . hasInitialization.
		#storageCreationNode . storageCreationNode encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> hasBasicInitialization [
	^ hasBasicInitialization
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> hasBasicInitialization: anObject [
	hasBasicInitialization := anObject
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> hasInitialization [
	^ hasInitialization
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> hasInitialization: anObject [
	hasInitialization := anObject
]

{ #category : #initialization }
MbndAstTemporaryVariableNode >> initialize [
	super initialize.
	hasBasicInitialization := true.
	hasInitialization := false.
]

{ #category : #testing }
MbndAstTemporaryVariableNode >> isTemporaryVariableNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstTemporaryVariableNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	storageCreationNode := aStorageCreationNode
]

{ #category : #serialization }
MbndAstTemporaryVariableNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	valueType := encodedFields at: #valueType.
	hasBasicInitialization := encodedFields at: #hasBasicInitialization.
	hasInitialization := encodedFields at: #hasInitialization.
	storageCreationNode := encodedFields at: #storageCreationNode.
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAstTemporaryVariableNode >> valueType: anObject [
	valueType := anObject
]

{ #category : #'as yet unclassified' }
MbndAstTemporaryVariableNode >> withInitialization [
	^ self copy
		hasInitialization: true
]
