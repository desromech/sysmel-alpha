Class {
	#name : #SGPUCompilationEnvironment,
	#superclass : #Object,
	#instVars : [
		'compilationModule',
		'compiledBlockClosures',
		'compiledShaderStages',
		'mbndToSlvmTypeMapCache'
	],
	#classVars : [
		'Current'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'SysmelGPUBlocks-Core-Compilation'
}

{ #category : #accessing }
SGPUCompilationEnvironment class >> current [
	^ Current ifNil: [ Current := self uniqueInstance ]
]

{ #category : #accessing }
SGPUCompilationEnvironment class >> reset [
	<script>
	uniqueInstance := nil.
	Current := nil.
]

{ #category : #accessing }
SGPUCompilationEnvironment class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
SGPUCompilationEnvironment >> compilationModule [
	^ compilationModule
]

{ #category : #accessing }
SGPUCompilationEnvironment >> compilationTarget [
	^ compilationModule compilationTarget
]

{ #category : #compiling }
SGPUCompilationEnvironment >> compileBlockClosure: blockClosure withTypeExpression: typeExpression [
	| parsedNode analyzedNode cacheKey convertedClosure |
	cacheKey := { blockClosure .  typeExpression}.
	compiledBlockClosures at: cacheKey ifPresent: [ :found | ^ found ].
	parsedNode := self parseBlockClosure: blockClosure withTypeExpression: typeExpression.

	convertedClosure := SGPUBlockClosure new
		cpuBlock: blockClosure;
		compilationEnvironment: self;
		yourself.
		
	compiledBlockClosures at: cacheKey put: convertedClosure.

	[ 
		analyzedNode := self newSemanticAnalyzer visitNode: parsedNode.
		convertedClosure concreteMethod: analyzedNode concreteMethod.
		analyzedNode concreteMethod ensureSemanticAnalysis
	] on: Error do: [ :e |
		compiledBlockClosures removeKey: cacheKey.
		convertedClosure := nil.
		e pass
	].

	^ convertedClosure
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> constructArrayOfType: typeExpression with: initialData [
	| type size slvmType cpuDataArray |
	type := self evaluateTypeExpression: typeExpression.
	size := initialData size.
	slvmType := self slvmTypeForMbndType: type.
	cpuDataArray := SLVMNativeArray for: slvmType new: size.
	1 to: size do: [ :i |
		cpuDataArray uncheckedAt: i put: (initialData at: i)
	].

	^ SGPUManagedDataArray basicNew
		initializeForType: type withCPUData: cpuDataArray
]

{ #category : #compiling }
SGPUCompilationEnvironment >> evaluateTypeExpression: typeExpression [
	| result resultValue |
	typeExpression = #() ifTrue: [
		^ self compilationTarget tuple: #()
	].

	result := (typeExpression isString and: [typeExpression isSymbol not]) ifTrue: [ 
		compilationModule evaluateLanguage: #pharoEmbedded source: typeExpression
	] ifFalse: [
		compilationModule analyzeAndEvaluateParsedSource: (self wrapParsedSource: (self parseTypeExpression: typeExpression))
	].

	resultValue := result unwrapMbndValue.
	resultValue isMbndType ifFalse: [
		self error: 'Expected a type expression instead of {1}.' format: { resultValue asString }
	].
	^ resultValue
]

{ #category : #initialization }
SGPUCompilationEnvironment >> initialize [
	super initialize.
	compilationModule := MbndStandaloneModule spirv_vulkan
		loadRuntimeCoreLibrary;
		evaluateFileNamedOnce: Smalltalk imageDirectory / 'lib' / 'gpu' / 'blocks' / 'blocks.sysmel'.
		
	compiledBlockClosures := WeakKeyDictionary new.
	compiledShaderStages := WeakKeyDictionary new.
	mbndToSlvmTypeMapCache := WeakKeyDictionary new.
]

{ #category : #compiling }
SGPUCompilationEnvironment >> newSemanticAnalyzer [
	^ MbndAstSemanticAnalyzer new
		scope: (compilationModule newSourceEvaluationScopeForLanguageNamed: #pharoEmbedded);
		module: compilationModule;
		yourself
]

{ #category : #compiling }
SGPUCompilationEnvironment >> parseBlockClosure: blockClosure withTypeExpression: typeExpression [
	| evaluatedType blockAstNode convertedAST sourceCode argumentTypes returnType blockClosureFunction |
	blockAstNode := blockClosure sourceNode.
	sourceCode := blockAstNode source asMoebiusBandCollectionWithContext.
	convertedAST := MbndRBAstConverter new
		convertAST: blockAstNode parsedFromSourceCollection: sourceCode withBuilder: (MbndAstBuilder forModule: compilationModule).
	self assert: convertedAST isMbndAstNode.
	self assert: convertedAST isBlockClosureNode.
	
	evaluatedType := self evaluateTypeExpression: typeExpression.
	argumentTypes := nil.
	returnType := nil.
	evaluatedType isFunctionType ifTrue: [
		argumentTypes := evaluatedType argumentTypes.
		returnType := evaluatedType returnType.
	] ifFalse: [ 
		evaluatedType isTupleType ifTrue: [
			argumentTypes := evaluatedType elements.
		] ifFalse: [
			argumentTypes := { evaluatedType }
		].
	].

	argumentTypes size = convertedAST arguments size ifFalse: [ 
		self error: 'Mismatching number of argument types.'
	].

	blockClosureFunction := convertedAST asFunctionDefinitionNode.
	blockClosureFunction prototype
		arguments: (blockClosureFunction prototype arguments collectWithIndex: [:arg :index |
			arg copy valueType: (argumentTypes at: index)
		]);
		returnType: returnType.

	^ blockClosureFunction
]

{ #category : #compiling }
SGPUCompilationEnvironment >> parseTypeExpression: typeExpression [
	typeExpression isSymbol ifTrue: [
		^ MbndAstIdentifierReferenceNode new
			symbol: typeExpression
	].

	self assert: typeExpression isArray.
	typeExpression ifEmpty: [
		^ (self compilationTarget tuple: #())
			asMoebiusLiteralValueNodeWithTarget: self compilationTarget
	].

	^ self parseTypeExpressionFrom: typeExpression readStream

]

{ #category : #compiling }
SGPUCompilationEnvironment >> parseTypeExpressionFrom: in [
	| result |
	result := self parseTypeExpression: in next.
	[ in atEnd ] whileFalse: [ 
		| token |
		token := in next.
		token isSymbol ifTrue: [
			| selector arguments |
			arguments := #().
			selector := token.
			token isBinary ifTrue: [
				arguments := {self parseTypeExpressionFrom: in}
			] ifFalse: [
				token last = $: ifTrue: [ 
					self halt
				].
			].

			result := MbndAstUnexpandedMessageSendNode new
				receiver: result;
				selector: (selector asMoebiusLiteralValueNodeWithTarget: self compilationTarget);
				arguments: arguments;
				yourself
		].
	].
	^ result

]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> shaderStageCodeFor: concreteMethod [
	| shaderStageType targetSSACodeModule spirVModule shaderSymbol shaderEntryPoint |
	^ compiledShaderStages at: concreteMethod ifAbsentPut: [
		shaderStageType := concreteMethod specialSemantics.
		self assert: shaderStageType isNotNil.
		compilationModule finishSemanticAnalysis.
	
		targetSSACodeModule := concreteMethod generateTargetCodeModuleOnlyForMyself.
		spirVModule := targetSSACodeModule asLowLevelModuleWithOptimizationLevel: compilationModule optimizationLevel.
		shaderSymbol := targetSSACodeModule highLevelMapToSymbol at: concreteMethod.
		shaderEntryPoint := spirVModule entryPoints at: shaderSymbol -> shaderStageType.
		SGPUShaderStageCode new
			spirVModule: spirVModule;
			entryPointMetadata: shaderEntryPoint;
			yourself
	]
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> slvmTypeForMbndType: mbndType [
	^ mbndToSlvmTypeMapCache at: mbndType ifAbsentPut: [
		compilationModule compilationTarget newCodeModuleGenerator
			generateCodeModuleFor: compilationModule programEntities: #();
			translateType: mbndType
	].

]

{ #category : #compiling }
SGPUCompilationEnvironment >> wrapParsedSource: ast [
	^ MbndLanguageParsedSource new
		ast: ast;
		language: (compilationModule getLanguageNamedFromCache: #pharoEmbedded);
		yourself
]
