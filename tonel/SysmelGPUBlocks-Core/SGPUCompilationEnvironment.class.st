Class {
	#name : #SGPUCompilationEnvironment,
	#superclass : #Object,
	#instVars : [
		'compiledBlockClosures',
		'compiledShaderStages',
		'compiledGenerators',
		'compilationEnvironment'
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
SGPUCompilationEnvironment >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
SGPUCompilationEnvironment >> compilationTarget [
	^ compilationEnvironment compilationTarget
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
	| type size cpuDataArray pharoCompatType |
	type := self evaluateTypeExpression: typeExpression.
	size := initialData size.
	pharoCompatType := type asPharoCompatLayerType.
	cpuDataArray := (StdnVector for: pharoCompatType) new: size.
	1 to: size do: [ :i |
		cpuDataArray add: (initialData at: i)
	].

	^ SGPUManagedDataArray basicNew
		compilationEnvironment: self;
		initializeForType: type withCPUData: cpuDataArray
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> constructArrayOfType: typeExpression withInterval: interval [
	^ self constructArrayOfType: typeExpression withSize: interval size withGenerator: (SGPUIntervalDataArrayGenerator new
	first: interval first;
	increment: interval increment;
	yourself)
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> constructArrayOfType: typeExpression withSize: size [
	| type pharoCompatType cpuDataArray |
	type := typeExpression isMbndType ifTrue: [ typeExpression ]
		ifFalse: [self evaluateTypeExpression: typeExpression].
	pharoCompatType := type asPharoCompatLayerType.
	cpuDataArray := (StdnVector for: pharoCompatType) new: size.
	cpuDataArray resizeTo: size.

	^ SGPUManagedDataArray basicNew
		compilationEnvironment: self;
		initializeForType: type withCPUData: cpuDataArray
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> constructArrayOfType: typeExpression withSize: size withGenerator: generator [
	| type pharoCompatType cpuDataArray |
	self assert: size >= 0.
	size = 0 ifTrue: [ ^ self constructArrayOfType: typeExpression with: size ].
	type := typeExpression isMbndType ifTrue: [ typeExpression ]
		ifFalse: [self evaluateTypeExpression: typeExpression].
	pharoCompatType := type asPharoCompatLayerType.
	cpuDataArray := (StdnVector for: pharoCompatType) new: size.
	cpuDataArray resizeTo: size.

	^ SGPUManagedDataArray basicNew
		compilationEnvironment: self;
		initializeForType: type withGenerator: generator cpuAllocationData: cpuDataArray
]

{ #category : #compiling }
SGPUCompilationEnvironment >> evaluateTypeExpression: typeExpression [
	| result resultValue |
	typeExpression = #() ifTrue: [
		^ self compilationTarget tuple: #()
	].

	result := (typeExpression isString and: [typeExpression isSymbol not]) ifTrue: [ 
		compilationEnvironment evaluateLanguage: #pharoEmbedded source: typeExpression
	] ifFalse: [
		compilationEnvironment analyzeAndEvaluateParsedSource: (self wrapParsedSource: (self parseTypeExpression: typeExpression))
	].

	resultValue := result unwrapMbndValue.
	resultValue isMbndType ifFalse: [
		self error: 'Expected a type expression instead of {1}.' format: { resultValue asString }
	].
	^ resultValue
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> getShaderTemplateNamed: templateName [
	| blockConversionNamespace |
	blockConversionNamespace := compilationEnvironment validCurrentModule globalNamespace lookupSymbol: #GPUBlockConversion.
	^ blockConversionNamespace lookupSymbol: templateName.

]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> getShaderTemplateNamed: templateName instanceWithArguments: arguments [
	| templateDefinition |
	templateDefinition := self getShaderTemplateNamed: templateName.
	^ (templateDefinition getOrCreateInstanceWithArguments: arguments)
		mainChild
]

{ #category : #initialization }
SGPUCompilationEnvironment >> initialize [
	super initialize.
	compilationEnvironment := MbndCompilationEnvironment spirv_vulkan
		monolithic;
		loadRuntimeCoreLibrary;
		importModuleNamed: #'Sysmel.GPU.Blocks';
		beginModule: #SGPUCompilationEnvironment.
		
	compiledBlockClosures := WeakKeyDictionary new.
	compiledShaderStages := WeakKeyDictionary new.
	compiledGenerators := WeakValueDictionary new.
]

{ #category : #'as yet unclassified' }
SGPUCompilationEnvironment >> intervalGenerationShaderStageCodeForValueType: valueType [
	^ compiledGenerators at: { #interval . valueType } ifAbsentPut: [
		| templateInstance method |
		templateInstance := self getShaderTemplateNamed: #IntervalGeneratorShader instanceWithArguments: { valueType }.
		method := templateInstance lookupSymbol: #main.
		self shaderStageCodeFor: method
	]

]

{ #category : #compiling }
SGPUCompilationEnvironment >> newSemanticAnalyzer [
	^ MbndAstSemanticAnalyzer new
		scope: (compilationEnvironment newSourceEvaluationScopeForLanguageNamed: #pharoEmbedded);
		module: compilationEnvironment;
		yourself
]

{ #category : #compiling }
SGPUCompilationEnvironment >> parseBlockClosure: blockClosure withTypeExpression: typeExpression [
	| evaluatedType blockAstNode convertedAST sourceCode argumentTypes returnType blockClosureFunction |
	blockAstNode := blockClosure sourceNode.
	sourceCode := blockAstNode source asMoebiusBandCollectionWithContext.
	convertedAST := MbndRBAstConverter new
		strictPharoMode: false;
		convertAST: blockAstNode parsedFromSourceCollection: sourceCode withBuilder: (MbndAstBuilder forModule: compilationEnvironment).
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
		compilationEnvironment finishSemanticAnalysis.
	
		targetSSACodeModule := concreteMethod generateTargetCodeModuleOnlyForMyself.
		spirVModule := targetSSACodeModule asLowLevelModuleWithOptimizationLevel: compilationEnvironment optimizationLevel.
		shaderSymbol := targetSSACodeModule highLevelMapToSymbol at: concreteMethod.
		shaderEntryPoint := spirVModule entryPoints at: shaderSymbol -> shaderStageType.
		SGPUShaderStageCode new
			spirVModule: spirVModule;
			entryPointMetadata: shaderEntryPoint;
			yourself
	]
]

{ #category : #compiling }
SGPUCompilationEnvironment >> wrapParsedSource: ast [
	^ MbndLanguageParsedSource new
		ast: ast;
		language: (compilationEnvironment getLanguageNamedFromCache: #pharoEmbedded);
		yourself
]
