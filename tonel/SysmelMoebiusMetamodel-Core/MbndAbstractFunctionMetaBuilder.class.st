Class {
	#name : #MbndAbstractFunctionMetaBuilder,
	#superclass : #MbndAbstractNamedMetaBuilder,
	#instVars : [
		'functionArguments',
		'returnTypeNode',
		'functionPrototype',
		'functionDefinition',
		'specialSemantics',
		'callingConvention'
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

{ #category : #'calling conventions' }
MbndAbstractFunctionMetaBuilder >> apicall [
	<compileTime>
	self callingConvention: #apicall
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

{ #category : #accessing }
MbndAbstractFunctionMetaBuilder >> callingConvention [
	^ callingConvention
]

{ #category : #accessing }
MbndAbstractFunctionMetaBuilder >> callingConvention: aCallingConvention [
	callingConvention := aCallingConvention
]

{ #category : #'calling conventions' }
MbndAbstractFunctionMetaBuilder >> cdecl [
	<compileTime>
	self callingConvention: #cdecl
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

{ #category : #flags }
MbndAbstractFunctionMetaBuilder >> dllexport [
	<compileTime>
	self addFlag: #dllexport
]

{ #category : #flags }
MbndAbstractFunctionMetaBuilder >> dllimport [
	<compileTime>
	self addFlag: #dllimport
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
	<compileTime>
	self addFlag: #externC
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> fragmentShader [
	^ self specialSemantics: #fragment
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> geometryShader [
	^ self specialSemantics: #geometry
]

{ #category : #'calling conventions' }
MbndAbstractFunctionMetaBuilder >> naked [
	<compileTime>
	self callingConvention: #naked
]

{ #category : #flags }
MbndAbstractFunctionMetaBuilder >> noReturn [
	<compileTime>
	self addFlag: #noReturn
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

{ #category : #'calling conventions' }
MbndAbstractFunctionMetaBuilder >> stdcall [
	<compileTime>
	self callingConvention: #stdcall
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> tessellationControlShader [
	^ self specialSemantics: #tessellationControl
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> tessellationEvaluationShader [
	^ self specialSemantics: #tessellationEvaluation
]

{ #category : #'special semantics' }
MbndAbstractFunctionMetaBuilder >> vertexShader [
	^ self specialSemantics: #vertex
]
