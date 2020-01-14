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
