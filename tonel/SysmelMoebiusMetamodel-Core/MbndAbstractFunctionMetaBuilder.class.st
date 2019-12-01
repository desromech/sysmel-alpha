Class {
	#name : #MbndAbstractFunctionMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'functionArguments',
		'returnTypeNode',
		'functionPrototype',
		'functionDefinition',
		'specialSemantics'
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

{ #category : #flags }
MbndAbstractFunctionMetaBuilder >> CVariadic [
	self addFlag: #cvariadic
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

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> computeShader [
	^ self specialSemantics: #compute
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
		ownerProgramEntity: ownerProgramEntity;
		flags: flags;
		name: name;
		arguments: functionArguments;
		returnType: returnTypeNode;
		specialSemantics: specialSemantics;
		yourself
]

{ #category : #flags }
MbndAbstractFunctionMetaBuilder >> externC [
	self addFlag: #externC
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> fragmentShader [
	^ self specialSemantics: #fragment
]

{ #category : #copying }
MbndAbstractFunctionMetaBuilder >> ownerProgramEntity: newOwner [
	super ownerProgramEntity: newOwner.
	functionPrototype ifNotNil: [ functionPrototype ownerProgramEntity: newOwner ]
]

{ #category : #copying }
MbndAbstractFunctionMetaBuilder >> postCopy [
	functionPrototype := functionPrototype copy.
	functionDefinition ifNotNil: [ 
		functionDefinition := functionDefinition copy.
		functionDefinition prototype: functionPrototype
	]

]

{ #category : #accessing }
MbndAbstractFunctionMetaBuilder >> specialSemantics [
	^ specialSemantics
]

{ #category : #accessing }
MbndAbstractFunctionMetaBuilder >> specialSemantics: anObject [
	specialSemantics := anObject
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> vertexShader [
	^ self specialSemantics: #vertex
]
