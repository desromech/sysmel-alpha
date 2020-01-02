Class {
	#name : #MbndTemplateMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'arguments',
		'templateArguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder class >> globalBindingName [
	^ #template
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> applyWithArguments: argumentsTemplateNode [
	templateArguments ifNotNil: [ self abortMetaBuilding ].
	name ifNil: [ name := #_ ].

	templateArguments := argumentsTemplateNode parseAsFunctionArgumentsPrototype.
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> assignValue: bodyNode [
	| templateDefinitionNode |
	templateDefinitionNode := self createTemplateDefinitionNode.
	templateDefinitionNode body: bodyNode.
	
	^ currentAnalyzer visitNode: templateDefinitionNode
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> checkTemplateArguments [
	templateArguments ifNil: [
		self error: 'Incomplete template definition without arguments.' at: position
	]
]

{ #category : #'semantic analysis' }
MbndTemplateMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	self error: 'Incomplete template definition.' at: node
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> createTemplateDefinitionNode [
	^ MbndAstTemplateDefinitionNode new
		position: position;
		name: name;
		arguments: templateArguments;
		ownerProgramEntity: ownerProgramEntity;
		yourself
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> delegateToMetaBuilder: newMetaBuilder [
	^ MbndAstTemplatedMetaBuilderInstanceNode new
		instance: (newMetaBuilder
			position: position;
			ownerProgramEntity: nil;
			metaBuilderAnalyzer: metaBuilderAnalyzer;
			metaBuilderScope: metaBuilderScope;
			name: (name isMbndAnonymousSymbol ifTrue: [ nil ] ifFalse: [#_])
			yourself);
		templateNode: self createTemplateDefinitionNode;
		type: metaBuilderAnalyzer compilationTarget metaBuilderInstanceType;
		position: position;
		yourself
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> function [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndFunctionMetaBuilder
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> gcclass [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndGCClassMetaBuilder
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> message [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndMethodMetaBuilder
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> nativeClass [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndClassMetaBuilder
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> struct [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndStructureMetaBuilder
]

{ #category : #'as yet unclassified' }
MbndTemplateMetaBuilder >> union [
	self checkTemplateArguments.
	^ self delegateToMetaBuilder: MbndUnionMetaBuilder
]
