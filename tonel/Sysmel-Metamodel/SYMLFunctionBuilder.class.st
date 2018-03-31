Class {
	#name : #SYMLFunctionBuilder,
	#superclass : #SYMLProgramEntityBuilder,
	#instVars : [
		'name',
		'arguments',
		'returnType',
		'function',
		'callingConvention',
		'functionType'
	],
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'meta methods' }
SYMLFunctionBuilder >> -> aReturnType [
	<compileTime>
	aReturnType type isMetaType ifFalse: [
		self error: 'Expected a type for the function return type.'.
	].

	returnType := aReturnType value.
	self function
]

{ #category : #'meta methods' }
SYMLFunctionBuilder >> CVariadic [
	<compileTime>
	self addFlag: #CVariadic
]

{ #category : #'meta methods' }
SYMLFunctionBuilder >> applyWithArguments: argumentNodes [
	<compileTime>
	<lazy>
	
	| evaluationEnvironment argumentName argumentType |
	evaluationEnvironment := argumentNodes environment.
	argumentNodes type isAPSGNode ifFalse: [
		self error: 'Expected an APSG node.'
	].

	argumentNodes value isTupleNode ifFalse: [ 
		self error: 'Expected an APSG tuple.'
	].

	arguments := argumentNodes value elements collect: [ :arg |
		arg isMessageNode ifFalse: [
			self error: 'Expected a message send to describe a function argument.' at: arg.
		].
	
		arg receiver ifNotNil: [ 
			self error: 'Function argument description must not have a receiver.' at: arg.
		].

		arg arguments size ~= 1 ifTrue: [ 
			self error: 'Function argument description must have only a single keyword.' at: arg.
		].
	
		argumentName := arg selector allButLast asSymbol.
		argumentType := arg arguments first analyzeAndEvaluateInEnvironment: evaluationEnvironment.
		argumentType type isMetaType ifFalse: [
			self error: 'Expected a type for argument {1}' format: { argumentName } at: arg arguments first
		].
		
		{argumentName . argumentType value . arg }
	].

]

{ #category : #'meta methods' }
SYMLFunctionBuilder >> assignValue: aDefinition [
	<compileTime>
	aDefinition type isAPSGNode ifFalse: [
		name ifNotNil: [ 
			self error: 'Expected an APSG/AST node for definition of function {1}.' format: {name}
		] ifNil: [
			self error: 'Expected an APSG/AST node for definition of function.'
		]
	].

	self function definition ifNotNil: [
		name ifNotNil: [ 
			self error: 'Redefining function {1}.' format: {name}
		] ifNil: [
			self error: 'Redefining function.'
		]
	].


	^ self function
		definition: aDefinition value;
		definitionEnvironment: (aDefinition environment ifNil: [definitionEnvironment ]);
		yourself
	
]

{ #category : #private }
SYMLFunctionBuilder >> buildFunction [
	| functionGroup targetProgramEntity |
	function := self constructFunction.
		
	name ifNotNil: [
		targetProgramEntity := definitionEnvironment findDefinitionProgramEntity.
		(definitionEnvironment hasSupportForOverloadedFunctions and: [self isExternC not]) ifTrue: [ 
			definitionEnvironment lookSymbol: name ifPresent: [ :existing |
				existing isFunctionGroup ifFalse: [ 
					self error: 'Cannot override program entity {1} with function.' format: { name }
				].
				functionGroup := existing
			] ifAbsentPut: [
				functionGroup := SYMLFunctionGroup new
					module: definitionEnvironment module;
					parent: targetProgramEntity;
					name: name;
					yourself.
					
				targetProgramEntity addedFunctionGroup: functionGroup.
				functionGroup
			].
		
			function := functionGroup findWithType: functionType ifAbsentPut: [
				targetProgramEntity addedFunction: function.
				function
			].
			
		] ifFalse: [
			definitionEnvironment lookSymbol: name ifPresent: [ :existing |
				existing isFunction ifFalse: [ 
					self error: 'Cannot override program entity {1} with function.' format: { name }
				].
			
				(function functionType ~= existing functionType) ifTrue: [ 
					self error: 'Cannot override overload function {1}.' format: { name }
				].
			
				function := existing
			] ifAbsentPut: [
				function parent: targetProgramEntity.
				targetProgramEntity addedFunction: function.
				function
			].
		].
	].

]

{ #category : #private }
SYMLFunctionBuilder >> buildFunctionType [
	| argumentTypes |
	returnType ifNil: [
		self error: 'Cannot build a function without a return type. You can use Void.'
	].
	argumentTypes := arguments collect: #second.
	
	functionType := self compilationTarget functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: self isCVariadic.

]

{ #category : #private }
SYMLFunctionBuilder >> constructFunction [
	^ SYMLFunction new
		name: name;
		module: definitionEnvironment module;
		functionType: self functionType;
		argumentNames: (arguments collect: #first);
		argumentNodes: (arguments collect: #third);
		flags: flags;
		yourself.
]

{ #category : #'meta methods' }
SYMLFunctionBuilder >> externC [
	<compileTime>
	self addFlag: #externC
]

{ #category : #accessing }
SYMLFunctionBuilder >> function [
	function ifNil: [ self buildFunction ].
	^ function
]

{ #category : #accessing }
SYMLFunctionBuilder >> functionType [
	functionType ifNil: [ self buildFunctionType ].
	^ functionType
]

{ #category : #initialization }
SYMLFunctionBuilder >> initialize [
	super initialize.
	callingConvention := #cdecl.
	
]

{ #category : #testing }
SYMLFunctionBuilder >> isCVariadic [
	<compileTime>
	^ self hasFlag: #CVariadic
]

{ #category : #testing }
SYMLFunctionBuilder >> isExternC [
	<compileTime>
	^ self hasFlag: #externC
]

{ #category : #accessing }
SYMLFunctionBuilder >> name [
	^ name
]

{ #category : #accessing }
SYMLFunctionBuilder >> name: anObject [
	name := anObject
]

{ #category : #'meta methods' }
SYMLFunctionBuilder >> type [
	<compileTime>
	^ self functionType
]
