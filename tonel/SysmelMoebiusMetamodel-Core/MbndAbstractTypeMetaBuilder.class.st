Class {
	#name : #MbndAbstractTypeMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'typeDefinitionNode',
		'typeDeclarationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndAbstractTypeMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	self ensureTypeDeclarationNode.
	self assert: typeDeclarationNode isNotNil.
	
	^ analyzer visitNode: (typeDefinitionNode
		ifNotNil: [ typeDefinitionNode ]
		ifNil: [ typeDeclarationNode ])
]

{ #category : #accessing }
MbndAbstractTypeMetaBuilder >> definition: newBodyNode [
	self halt
]

{ #category : #'semantic analysis' }
MbndAbstractTypeMetaBuilder >> ensureTypeDeclarationNode [
	typeDeclarationNode ifNotNil: [ ^ self ].
	
	typeDeclarationNode := self typeDeclarationNodeClass new
		position: position;
		name: name;
		yourself
]

{ #category : #accessing }
MbndAbstractTypeMetaBuilder >> extend: newBodyNode [
	self halt
]

{ #category : #'semantic analysis' }
MbndAbstractTypeMetaBuilder >> typeDeclarationNodeClass [
	self subclassResponsibility
]

{ #category : #'semantic analysis' }
MbndAbstractTypeMetaBuilder >> typeDefinitionNodeClass [
	self subclassResponsibility
]
