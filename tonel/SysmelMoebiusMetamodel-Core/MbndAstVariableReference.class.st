Class {
	#name : #MbndAstVariableReference,
	#superclass : #MbndAstSymbolReference,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariableReference >> accept: aVisitor [
	^ aVisitor visitVariableReferenceNode: self
]

{ #category : #testing }
MbndAstVariableReference >> isSuperReference [
	^ binding isFunctionSuperReceiverReference
]

{ #category : #testing }
MbndAstVariableReference >> isVariableReferenceNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstVariableReference >> markStorageCreationNodeForCopyEllision: storageCreationNode [
	binding isFunctionLocalVariable ifFalse: [ ^ self ].
	self flag: 'TODO: Validate whether the storage creation exists before the variable. For now only support the return nodes.'.
	storageCreationNode isReturnStatementNode ifFalse: [ ^ self ].
	binding definitionNode markStorageCreationNodeForCopyEllision: storageCreationNode
]
