Class {
	#name : #MbndAbstractFunctionMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'functionArguments',
		'returnTypeNode',
		'functionPrototype',
		'functionDefinition'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndAbstractFunctionMetaBuilder >> => aReturnType [
	functionPrototype ifNotNil: [ self abortMetaBuilding ].
	functionArguments ifNil: [ functionArguments := #() ].
	returnTypeNode := aReturnType.
	self ensureFunctionPrototype
]

{ #category : #'as yet unclassified' }
MbndAbstractFunctionMetaBuilder >> applyWithArguments: prototypeTemplate [
	functionArguments ifNotNil: [ self abortMetaBuilding ].
	functionPrototype ifNotNil: [ self abortMetaBuilding ].
	functionArguments := prototypeTemplate parseAsFunctionArgumentsPrototype.
]

{ #category : #definition }
MbndAbstractFunctionMetaBuilder >> assignValue: aNode [
	^ self definition: aNode
]

{ #category : #'semantic analysis' }
MbndAbstractFunctionMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	self ensureFunctionPrototype.
	
	^ analyzer visitNode: (functionDefinition
		ifNotNil: [ functionDefinition ]
		ifNil: [ functionPrototype ])
]

{ #category : #'as yet unclassified' }
MbndAbstractFunctionMetaBuilder >> createFunctionDefinition [
	self ensureFunctionPrototype.
	functionDefinition := MbndAstFunctionDefinitionNode new
		position: position;
		prototype: functionPrototype;
		yourself
]

{ #category : #definition }
MbndAbstractFunctionMetaBuilder >> definition: aNode [
	(functionDefinition isNotNil and: [functionDefinition body isNotNil]) ifTrue: [
		 ^ self abortMetaBuilding
	].

	functionPrototype ifNil: [ self ensureFunctionPrototype  ].
	self createFunctionDefinition.
	functionDefinition body: aNode
]

{ #category : #'as yet unclassified' }
MbndAbstractFunctionMetaBuilder >> ensureFunctionPrototype [
	functionPrototype ifNotNil: [ ^ self ].
	functionPrototype := MbndAstFunctionPrototypeNode new
		position: position;
		name: name;
		arguments: functionArguments;
		returnType: returnTypeNode;
		yourself
]
