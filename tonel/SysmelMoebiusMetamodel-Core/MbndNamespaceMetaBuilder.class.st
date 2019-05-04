Class {
	#name : #MbndNamespaceMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'bodyNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndNamespaceMetaBuilder class >> globalBindingName [
	^ #namespace
]

{ #category : #definition }
MbndNamespaceMetaBuilder >> assignValue: newBodyNode [
	self definition: newBodyNode
]

{ #category : #'semantic analysis' }
MbndNamespaceMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	name ifNil: [
		analyzer error: 'Namespace definition without a name.' at: node
	].

	^ analyzer visitNode: (MbndAstNamespaceDefinitionNode new
		position: position;
		ownerProgramEntity: ownerProgramEntity;
		name: name;
		body: bodyNode;
		yourself)
]

{ #category : #definition }
MbndNamespaceMetaBuilder >> definition: newBodyNode [
	bodyNode := newBodyNode
]
