Class {
	#name : #MbndAstAbstractTypeDeclarationNode,
	#superclass : #MbndAstAbstractProgramEntityDeclarationNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstAbstractTypeDeclarationNode >> ensurePartOfDefinitionFlagIsMarked [
	self isPartOfDefinition ifTrue: [ ^ self ].
	^ self copy
		addFlag: #partOfDefinition;
		yourself
]

{ #category : #testing }
MbndAstAbstractTypeDeclarationNode >> isPartOfDefinition [
	^ self hasFlag: #partOfDefinition
]
