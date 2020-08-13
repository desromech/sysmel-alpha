Class {
	#name : #MbndSlovimCodeModuleGenerator,
	#superclass : #MbndAbstractCodeModuleGenerator,
	#instVars : [
		'sourceModule',
		'ssaModule',
		'translatedProgramEntities',
		'typeTranslator',
		'anonSymbolCount',
		'debugLocationDictionary',
		'debugSourceFileDictionary',
		'identityHashRandomGenerator',
		'intrinsicConstantBuiltInFunctionCache',
		'convertedDescriptorSetBindings',
		'structuresWithAdditionalKinds',
		'convertedShaderIOFields',
		'generatedNameTable',
		'debugTypeTranslator',
		'symbolNameManglerPrototype',
		'dynamicFunctionCallsAdapters',
		'shaderEntryPointInfoDictionary',
		'compilationTargetOverride',
		'landingPathResultType',
		'personalityFunction',
		'forbiddenExceptionHandlingFunction',
		'exceptionCatchEndFunction',
		'exceptionCatchBeginFunction',
		'nonLocalReturnRaiseFunction',
		'nonLocalReturnCatchFunction',
		'objectMethodDispatchTrampolines',
		'nativeClosureTypeInfos',
		'targetCodeModuleName',
		'gpuUsableProgramEntitites',
		'patternMatchingFailureRaiseFunction',
		'variantUnexpectedComponentRaiseFunction',
		'nativeShaderEntryPoints',
		'indexOutOfBoundsRaiseFunction',
		'sampleTextureImplicitLodFunction',
		'sampleTextureExplicitLodFunction',
		'sampleTextureExplicitDerivativesFunction',
		'constructionRecordDictionary',
		'constructionRecords',
		'sysmelAtExitFunction',
		'exceptionSetjmpFunction',
		'exceptionLongjmpFunction',
		'exceptionContextBeginFunction',
		'exceptionCleanUpEndFunction',
		'exceptionContextEndFunction'
	],
	#classVars : [
		'ShaderBuiltInLocationMap',
		'ShaderTypeToStageType'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimCodeModuleGenerator class >> initialize [
	ShaderBuiltInLocationMap := Dictionary newFromPairs: #(
		"Vertex outputs"
		(vertex position) -1
		(vertex pointSize) -2
		(vertex clipDistance) -3

		"Vertex inputs"
		(vertex vertexID) -43
		(vertex instanceID) -44

		"Fragment inputs"
		(fragment fragCoord) -16
		(fragment pointCoord) -17
		(fragment frontFacing) -18

		"Compute inputs"
		(compute workgroupCount) -25
		(compute workgroupSize) -26
		(compute workgroupID) -27
		(compute localInvocationID) -28
		(compute globalInvocationID) -29
		(compute localInvocationIndex) -30
	).
	
	ShaderTypeToStageType := Dictionary newFromPairs: #(
		vertex 0 "AGPU_VERTEX_SHADER"
		fragment 1 "AGPU_FRAGMENT_SHADER"
		geometry 2 "AGPU_GEOMETRY_SHADER"
		compute 3 "AGPU_COMPUTE_SHADER"
		tcontrol 4 "AGPU_TESSELLATION_CONTROL_SHADER"
		teval 5 "AGPU_TESSELLATION_EVALUATION_SHADER"
	)
	
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> addPrimitiveTypeTranslations [
	| sourceTarget destTarget sourceType destType |
	sourceTarget := sourceModule compilationTarget.
	destTarget := self slvmCompilationTarget.
	
	(#(
		(voidType void)

		(char8Type uint8)
		(char16Type uint16)
		(char32Type uint32)

		(uint8Type uint8)
		(uint16Type uint16)
		(uint32Type uint32)
		(uint64Type uint64)

		(int8Type int8)
		(int16Type int16)
		(int32Type int32)
		(int64Type int64)

		(float32Type float32)
		(float64Type float64)

		(booleanType bool)
		(undefinedType voidPointerType)
		(valistType valist)
	) , self gpuTypeMapping)
	 do: [ :pair |
		sourceType := sourceTarget perform: pair first.
		destType := destTarget perform: pair second.
		self typeTranslator setType: sourceType ssaType: destType
	].

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> addUnmangledProgramEntity: programEntity suffixInto: out [
	"TODO: Add the function type string here."
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> compilationEnvironment [
	^ sourceModule compilationEnvironment
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> compilationTarget [
	^ compilationTargetOverride ifNil: [ sourceModule compilationTarget ]
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> compilationTargetOverride [
	^ compilationTargetOverride
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> compilationTargetOverride: aCompilationTarget [
	^ compilationTargetOverride := aCompilationTarget
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> convertDebugPosition: aPosition [
	^ self convertDebugPosition: aPosition scope: nil
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> convertDebugPosition: aPosition scope: lexicalScope [
	^ debugLocationDictionary at: {aPosition . lexicalScope} ifAbsentPut: [ SLVMDebugLocation new
			sourceFile: (self convertDebugSourceFile: aPosition collection);
			start: aPosition start;
			stop: aPosition stop;
			startLine: aPosition line;
			startColumn: aPosition column;
			endLine: aPosition endLine;
			endColumn: aPosition endColumn;
			collection: aPosition collection;
			scope: lexicalScope;
			yourself ]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> convertDebugSourceFile: aSourceCollection [
	| sourceRef |
	^ debugSourceFileDictionary at: aSourceCollection ifAbsentPut: [ 
		sourceRef := (aSourceCollection ifNil: ['generated'] ifNotNil: [
				aSourceCollection isString
					ifTrue: [aSourceCollection]
					ifFalse: [aSourceCollection name]]) asFileReference.
		SLVMDebugSourceFile new
			directory: sourceRef parent fullName;
			name: sourceRef basename
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> convertExtensionMacroInformation: extensionDescription [
	^ self compilationTarget extensionMacroMessageClass makeInstance
		setField: #extendedParent value: extensionDescription first;
		setField: #name value: extensionDescription second;
		setField: #extension value: extensionDescription third;
		yourself
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> convertExtensionMethodInformation: extensionDescription [
	^ self compilationTarget extensionMethodClass makeInstance
		setField: #extendedParent value: extensionDescription first;
		setField: #name value: extensionDescription second;
		setField: #extension value: extensionDescription third;
		yourself
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> convertExtensionOverloadedMethodInformation: extensionDescription [
	^ self compilationTarget extensionOverloadedMethodClass makeInstance
		setField: #extendedParent value: extensionDescription first;
		setField: #name value: extensionDescription second;
		setField: #extension value: extensionDescription third;
		yourself
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> createCPUShaderControllerFor: functionMethod generatedAs: ssaFunction [
	| csymbol stageioInterface receiverType controllerFunctionType ssaFunctionType controllerSSAFunction builder ioChannels inputsField outputsField inputsLocationsField outputsLocationsField receiver |
	stageioInterface := self compilationTarget nativeShaderIOInterfaceWithSemantics: functionMethod specialSemantics.
	stageioInterface ifNil: [ ^ nil ].
	csymbol := self newSymbolNameMangler mangleProgramEntityName: functionMethod suffixes: {#'..shinterface..'}.

	"We always keep a receiver pointer."
	receiverType := functionMethod receiverType.
	
	controllerFunctionType := (self compilationTarget voidType pointer pointer , stageioInterface ref) => self compilationTarget voidType.
	ssaFunctionType := self translateType: controllerFunctionType.
	controllerSSAFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	controllerSSAFunction unmangledName: functionMethod qualifiedName  , '[ShaderController]'.
	nativeShaderEntryPoints at: functionMethod put: controllerSSAFunction.
	self isEmittingDebugInformation ifTrue: [
		controllerSSAFunction
			debugInformation: (self debugInformationTranslator createForShader: functionMethod controllerWithFunctionType: controllerFunctionType);
			debugSourceLocation: (self convertDebugPosition: functionMethod validSourcePosition asActualSourcePosition)
	].

	builder := SLVMBuilder on: controllerSSAFunction.
	builder newBasicBlockHere: #entry.
	self isEmittingDebugInformation ifTrue: [ 
		builder pushDebugSourcePosition: (self convertDebugPosition: functionMethod definitionPosition asActualSourcePosition scope: nil)
	].
	
	inputsField := stageioInterface findFirstFieldNamed: #inputs.
	outputsField := stageioInterface findFirstFieldNamed: #outputs.
	inputsLocationsField := inputsField ifNotNil: [
		inputsField valueType findFirstFieldNamed: #locations
	].
	outputsLocationsField := outputsField ifNotNil: [
		outputsField valueType findFirstFieldNamed: #locations
	].

	"Alloca the receiver"
	receiver := nil.
	functionMethod receiverType isVoidType ifFalse: [ 
		receiver := builder alloca: (self translateType: functionMethod receiverType baseType)
	].


	"Alloca the channels"
	self assert: functionMethod returnType isVoidType.
	self assert: (functionMethod boundType argumentTypes allSatisfy: [:each |
		each isIOChannelType and: [ each specialSemantics = functionMethod specialSemantics ] 
	]).

	ioChannels := functionMethod boundType argumentTypes collect: [ :each |
		builder alloca: (self translateType: each messageType)
	].

	ioChannels do: [:each |
		builder store: (SLVMConstant zeroInitializer: each type baseType) in: each
	].

	receiver ifNotNil: [ 
		builder store: (SLVMConstant zeroInitializer: receiver type baseType) in: receiver.
		self fetchNativeShader: functionMethod rootDescriptorTable: functionMethod receiverType withoutReferences withoutTopDecorations constantsFrom: controllerSSAFunction arguments first into: receiver with: builder.
	].

	"Copy the inputs"
	functionMethod boundType argumentTypes doWithIndex: [ :eachChannelType :index |
		eachChannelType isInputChannelType ifTrue: [
			self fetchNativeShader: functionMethod inputsOfType: eachChannelType messageType
				into: (ioChannels at: index) from: controllerSSAFunction arguments second
				inputsField: inputsField inputsLocationsField: inputsLocationsField
				with: builder
		]
	].

	"Invoke the shader itself"
	functionMethod receiverType isVoidType ifTrue: [ 
		builder call: ssaFunction arguments: ioChannels
	] ifFalse: [ 
		builder call: ssaFunction arguments: {receiver} , ioChannels
	].
	
	"Copy the outputs"
	functionMethod boundType argumentTypes doWithIndex: [ :eachChannelType :index |
		eachChannelType isOutputChannelType ifTrue: [
			self storeNativeShader: functionMethod outputsOfType: eachChannelType messageType
				from: (ioChannels at: index) into: controllerSSAFunction arguments second
				outputsField: outputsField outputsLocationsField: outputsLocationsField
				with: builder
		]
	].

	builder returnVoid
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> createFunctionCodeGenerator [
	^ MbndSlovimFunctionCodeGenerator new
		codeModuleGenerator: self;
		yourself
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> createModuleInfoStartupConstructors: moduleInfoGlobal [
	| moduleStartUpFunction moduleShutDownFunction functionType ctor dtor |
	moduleStartUpFunction := self compilationTarget managedObjectModel moduleStartUpFunction.
	moduleShutDownFunction := self compilationTarget managedObjectModel moduleShutDownFunction.
	(moduleStartUpFunction isNil or: [moduleShutDownFunction isNil]) ifTrue: [ ^ self ].
	
	functionType := self compilationTarget voidType => self compilationTarget voidType.
	ctor := self translateCompilerGeneratedMethodNamed: #'..sysmel.module.startUp..' functionType: functionType
		at: MbndSourcePosition empty
		with: [:ssaFunction :builder :functionCodeGenerator |
		ssaFunction makePrivate.
		
		builder
			call: (self translateProgramEntity: moduleStartUpFunction) ssaValue arguments: { moduleInfoGlobal };
			returnVoid
	].

	dtor := self translateCompilerGeneratedMethodNamed: #'..sysmel.module.shutdown..' functionType: functionType
		at: MbndSourcePosition empty
		with: [:ssaFunction :builder :functionCodeGenerator |
		ssaFunction makePrivate.
		
		builder
			call: (self translateProgramEntity: moduleShutDownFunction) ssaValue arguments: { moduleInfoGlobal };
			returnVoid
	].
	
	constructionRecords add: (MbndSlovimConstructionRecord new
		constructor: ctor;
		destructor: dtor;
		priority: self compilationTarget gcModuleStartUpPriority).

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> createSpirVShaderControllerFor: functionMethod generatedAs: generatedSSAFunction [
	| csymbol shaderFunction builder argumentTypes receiverType receiver invocationArguments inputChannels outputChannels boundArguments fetchedInputs computedOutputs |
	csymbol := self unmangledNameForShaderEntryPoint: functionMethod.
	(functionMethod hasFlag: #externC) ifTrue: [
		csymbol := functionMethod name.
	].

	receiverType := self translateType: functionMethod receiverType.
	argumentTypes := functionMethod boundType argumentTypes.
	inputChannels := (argumentTypes collectWithIndex: [ :argumentType :index |
		{argumentType . index}
	]) select: [:pair | pair first isInputChannelType].
	outputChannels := (argumentTypes collectWithIndex: [ :argumentType :index |
		{argumentType . index}
	]) select: [:pair | pair first isOutputChannelType].

	shaderFunction := SLVMFunction module: ssaModule name: csymbol functionType: (SLVMFunctionType arguments: #() returnType: SLVMType voidType).
	shaderFunction propertyAt: functionMethod specialSemantics put: nil.
	ssaModule addHighLevelEntity: functionMethod mapToGlobalValue: shaderFunction.
	
	functionMethod specialSemantics = #compute ifTrue: [
		shaderFunction
			propertyAt: #localSizeX put: functionMethod computeShaderLocalSize first;
			propertyAt: #localSizeY put: functionMethod computeShaderLocalSize second;
			propertyAt: #localSizeZ put: functionMethod computeShaderLocalSize third.
	].
	
	builder := SLVMBuilder on: shaderFunction.
	builder newBasicBlockHere: #entry.
	
	"Allocate space for the IO data."
	receiver := receiverType isVoidType ifTrue: [nil] ifFalse: [builder alloca: receiverType baseType].
	boundArguments := Array new: argumentTypes size.
	
	fetchedInputs := inputChannels collect: [ :channel | builder alloca: (self translateType: channel first messageType) ].
	computedOutputs := outputChannels collect: [ :channel | builder alloca: (self translateType: channel first messageType) ].

	"Fetch the inputs."
	fetchedInputs doWithIndex: [ :fetchedInput :index |
		| stageInputType |
		stageInputType := (inputChannels at: index) first.
		boundArguments at: (inputChannels at: index) second put: fetchedInput.
		self fetchShader: functionMethod inputsOfType: stageInputType messageType into: fetchedInput with: builder.
	].

	computedOutputs doWithIndex: [ :computedOutput :index |
		boundArguments at: (outputChannels at: index) second put: computedOutput.
	].
	
	"Call the actual shader content."
	invocationArguments := boundArguments.
	receiver ifNotNil: [ invocationArguments := { receiver } , invocationArguments ].

	builder call: generatedSSAFunction arguments: invocationArguments.
	
	"Copy the computed results."
	computedOutputs doWithIndex: [ :computedOutput :index |
		| stageOutputType |
		stageOutputType := (outputChannels at: index) first.
		self storeShader: functionMethod outputsOfType: stageOutputType messageType from: computedOutput with: builder.
	].
	
	builder returnVoid.
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> csymbolForProgramEntity: programEntity [
	programEntity name ifNil: [ ^ nil ].

	(programEntity hasFlag: #externC) ifTrue: [
		(self slvmCompilationTarget isGPU and: [ programEntity specialSemantics isNotNil ]) ifFalse: [ 
			^ programEntity name
		].
	].

	^ self mangleProgramEntityName: programEntity
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> debugInformationTranslator [
	^ debugTypeTranslator ifNil: [ debugTypeTranslator := MbndSlovimDebugInformationTranslator new codeModuleGenerator: self ]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> ensureRequiredStructuresAreDefined [
	self slvmCompilationTarget isGPU ifTrue: [ ^ self ].
	
	self compilationTarget managedObjectModel runtimeImportantFunctions do: [:eachFunction |
		self translateProgramEntity: eachFunction
	].
	self compilationTarget managedObjectModel runtimeImportantClasses do: [:eachClass |
		ssaModule importType: (self translateType: eachClass) fromModule: nil.
		eachClass isGCClassType ifTrue: [ 
			ssaModule importType: (self translateType: eachClass type) fromModule: nil.
		]
	].
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionCatchBeginFunction [
	^ exceptionCatchBeginFunction ifNil: [
		self compilationTarget exceptionCatchBeginFunction ifNotNil: [ :function |
			exceptionCatchBeginFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionCatchBeginFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_catchBegin
				functionType: (SLVMFunctionType arguments: {self slvmCompilationTarget voidPointerType} returnType: self slvmCompilationTarget voidPointerType)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionCatchEndFunction [
	^ exceptionCatchEndFunction ifNil: [
		self compilationTarget exceptionCatchEndFunction ifNotNil: [ :function |
			exceptionCatchEndFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionCatchEndFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_catchEnd
				functionType: (SLVMFunctionType arguments: #() returnType: SLVMType voidType)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionCatchEndFunctionWithContext [
	^ exceptionCatchEndFunction ifNil: [
		self compilationTarget exceptionCatchEndFunction ifNotNil: [ :function |
			exceptionCatchEndFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionCatchEndFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_catchEnd
				functionType: (SLVMFunctionType arguments: {self slvmCompilationTarget voidPointerType} returnType: SLVMType voidType)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionCleanUpEndFunction [
	^ exceptionCleanUpEndFunction ifNil: [
		self compilationTarget exceptionCleanUpEndFunction ifNotNil: [ :function |
			exceptionCleanUpEndFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionCleanUpEndFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_cleanUpEnd
				functionType: (SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: SLVMType voidType
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionContextBeginFunction [
	^ exceptionContextBeginFunction ifNil: [
		self compilationTarget exceptionContextBeginFunction ifNotNil: [ :function |
			exceptionContextBeginFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionContextBeginFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_contextBegin
				functionType: (SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: SLVMType voidType
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionContextEndFunction [
	^ exceptionContextEndFunction ifNil: [
		self compilationTarget exceptionContextEndFunction ifNotNil: [ :function |
			exceptionContextEndFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionContextEndFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_contextEnd
				functionType: (SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: SLVMType voidType
				)
		]
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> exceptionHandlingCodeGeneratorClass [
	self hasExceptions ifFalse: [ ^ MbndSlovimFunctionNullExceptionHandlingCodeGenerator ].
	self compilationTarget hasNoExceptionModel ifTrue: [ ^ MbndSlovimFunctionExplicitSJLJExceptionHandlingCodeGenerator ].
	^ MbndSlovimFunctionLandingPadExceptionHandlingCodeGenerator
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionLongjmpFunction [
	^ exceptionLongjmpFunction ifNil: [
		self compilationTarget exceptionLongjmpFunction ifNotNil: [ :function |
			exceptionLongjmpFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionLongjmpFunction := (SLVMFunction module: ssaModule
				name: #_longjmp
				functionType: (SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType . SLVMType intType } returnType: SLVMType voidType))
					setNoReturn: true;
					yourself
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> exceptionSetjmpFunction [
	^ exceptionSetjmpFunction ifNil: [
		self compilationTarget exceptionSetjmpFunction ifNotNil: [ :function |
			exceptionSetjmpFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			exceptionSetjmpFunction := (SLVMFunction module: ssaModule
				name: #_setjmp
				functionType: (SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: SLVMType intType))
					doesHaveMultipleReturns: true
		]
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> fetchNativeShader: functionMethod inputsOfType: inputMessageType
into: inputStorage from: ioInterface
inputsField: inputsField inputsLocationsField: inputsLocationsField
with: builder [
	inputMessageType slotLayout slots do: [ :slot |
		| slotField inputField |
		self assert: slot fields size = 1.
		slotField := slot fields first.
		inputField := nil.
		
		slotField intrinsic ifNotNil: [ :intrinsicName |
			| intrisicField |
			intrisicField := inputsField valueType findFieldWithIntrinsicNamed: intrinsicName.
			intrisicField ifNotNil: [
				inputField := builder getPointer: ioInterface element: {
					builder constInt: 0.
					builder constInt: inputsField slotIndex.
					builder constInt: intrisicField slotIndex.
				}.
			].
		].
		slotField location ifNotNil: [ :location |
			(inputsLocationsField isNotNil and: [
			location isInteger and: [
			0 <= location and: [
			location < inputsLocationsField valueType elements ]]]) ifTrue: [
				inputField := builder getPointer: ioInterface element: {
					builder constInt: 0.
					builder constInt: inputsField slotIndex.
					builder constInt: inputsLocationsField slotIndex.
					builder constInt: location.
				}.
	 		]
		].
	
		inputField ifNotNil: [ 
			| inputStorageField |
			inputStorageField := builder getReference: inputStorage element: (builder constInt: slotField slotIndex).
	
			inputField type baseType ~= inputStorageField type baseType ifTrue: [ 
				inputField := builder bitCast: inputField target: inputStorageField type
			].

			builder store: (builder load: inputField) in: inputStorageField
		].
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> fetchNativeShader: functionMethod rootDescriptorTable: receiverType constantsFrom: rootDescriptorTablePointer into: receiver with: builder [
	receiverType slotLayout slots do: [ :eachSlot |
		eachSlot fields size = 1 ifTrue: [ 
			| field valueType |
			field := eachSlot fields first.
			valueType := field valueType.
			field isDescriptorSetBinding ifTrue: [
				| setIndex setPointer |
				setIndex := field asDescriptorSetIndex.
				setPointer := builder load: (builder getPointer: rootDescriptorTablePointer element: {builder constInt: setIndex}).
				setPointer := builder bitCast: setPointer target: (self translateType: valueType).
				builder store: setPointer in: (builder getReference: receiver element: (builder constInt: field slotIndex)).
			]
		]
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> fetchShader: functionMethod inputsOfType: inputMessageType into: inputFetchedLocation with: builder [
	| slotField inputGlobal |
	self assert: inputMessageType isAggregateType.
	inputMessageType slotLayout slots do: [ :slot |
		self assert: slot fields size = 1.
		slotField := slot fields first.
		inputGlobal := self getShaderIOField: slotField storage: SLVMType inputStorage forStage: functionMethod specialSemantics.
		builder store: (builder load: inputGlobal)
			in: (builder getReference: inputFetchedLocation element: (builder constInt: slotField slotIndex))
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> fillModuleInfoInstance: moduleInfoInstance [
	moduleInfoInstance
		setField: #name ifExistsWith: [ sourceModule name asSymbol ];
		setField: #globalNamespace ifExistsWith: [ sourceModule globalNamespace ].
			
	"self compilationTarget extensionMacroMessageClass ifNotNil: [
		moduleInfoInstance
			setField: #extensionMacros ifExistsWith: [ sourceModule extensionMacros collect: [ :each | self convertExtensionMacroInformation: each ] as: Array ]
	]."

	self compilationTarget extensionOverloadedMethodClass ifNotNil: [
		moduleInfoInstance	
			setField: #extensionOverloadedMethods ifExistsWith: [ sourceModule extensionOverloadedMethods collect: [ :each | self convertExtensionOverloadedMethodInformation: each ] as: Array ].
	].

	self compilationTarget extensionMethodClass ifNotNil: [
		moduleInfoInstance	
			setField: #extensionMethods ifExistsWith: [ sourceModule extensionMethods collect: [ :each | self convertExtensionMethodInformation: each ] as: Array ]
	].

]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> forbiddenExceptionHandlingFunction [
	^ forbiddenExceptionHandlingFunction ifNil: [
		self compilationTarget forbiddenExceptionHandlingFunction ifNotNil: [ 
			forbiddenExceptionHandlingFunction := (self translateProgramEntity: self compilationTarget forbiddenExceptionHandlingFunction) ssaValue
		] ifNil: [
			forbiddenExceptionHandlingFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_handleForbiddenException
				functionType: ((SLVMFunctionType arguments: #() returnType: SLVMType voidType)
					variadic: true
				)
		]
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> generateAnonCompilerGeneratedMethodWithType: functionType allowGC: allowGC debugInformationWith: debugInformationBlock with: codeGenerationBlock [
	| ssaFunctionType ssaFunction dummyMethod |
	ssaFunctionType := self translateType: functionType.
	dummyMethod := MbndDummyMethod new
		type: functionType;
		boundType: functionType;
		receiverType: self compilationTarget voidType;
		yourself.

	ssaFunction := SLVMFunction module: ssaModule name: nil functionType: ssaFunctionType.

	self isEmittingDebugInformation ifTrue: [
		ssaFunction
			debugInformation: debugInformationBlock value;
			debugSourceLocation: (self convertDebugPosition: self validSourcePosition)
	].

	ssaFunction makePrivate.
	
	(allowGC and: [sourceModule hasGarbageCollectionStackMap]) ifTrue: [
		ssaFunction gcStrategy: #sysmel
	].
	
	self createFunctionCodeGenerator
			buildSSAFunction: ssaFunction definitionWithMethod: dummyMethod
			withCodeGenerationBlock: codeGenerationBlock.

	^ ssaFunction
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule [
	^ self generateCodeModuleFor: aModule programEntities: { aModule }
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule name: codeModuleName [
	^ self generateCodeModuleFor: aModule programEntities: { aModule } name: codeModuleName
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule programEntities: programEntitities name: theTargetCodeModuleName [
	sourceModule := aModule.
	ssaModule := SLVMModule new compilationTarget: self slvmCompilationTarget.
	ssaModule sourceLanguageName: 'C++'. "HACK"
	theTargetCodeModuleName ifNotNil: [ aModule namedTargetCodeModules at: theTargetCodeModuleName put: ssaModule ].
	targetCodeModuleName := theTargetCodeModuleName.
	
	self addPrimitiveTypeTranslations.
	programEntitities do: [ :each | self translateProgramEntity: each ].
	ssaModule nonInlineLiterals do: [ :each | self generateNonInlineLiteralValue: each ].
	self ensureRequiredStructuresAreDefined.
	^ ssaModule
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateEmbeddedShaderModule [
	| shaderCompilationTarget shaderModuleCodeGenerator shaderSSAModule spirVModule spirVModuleBlobData spirVModuleBlob spirVModuleInfoGlobal shaderEntryPoints |
	self compilationTarget isGPU ifTrue: [ ^ nil ].
	self compilationTarget shaderModuleInfo ifNil: [ ^ nil ].
	gpuUsableProgramEntitites ifEmpty: [ ^ nil ].
	shaderCompilationTarget := self compilationTarget asSpirVCompilationTarget.
	shaderModuleCodeGenerator := shaderCompilationTarget newCodeModuleGenerator.
	shaderModuleCodeGenerator compilationTargetOverride: shaderCompilationTarget.
	shaderSSAModule := MbndProfiler component: #shaderIRCodeGeneration with: [shaderModuleCodeGenerator generateCodeModuleFor: sourceModule programEntities: gpuUsableProgramEntitites name: #spirv].
	shaderEntryPoints := gpuUsableProgramEntitites select: [ :each | each isConcreteMethod and: [ each specialSemantics isNotNil ] ].

	shaderEntryPoints ifEmpty: [^ nil].
	
	shaderSSAModule disableSLVMOptimizations: MbndStandaloneModule disableSLVMOptimizations.
	spirVModule := shaderSSAModule asLowLevelModuleWithOptimizationLevel: sourceModule optimizationLevel.
	spirVModuleBlobData := spirVModule bytes.
	sourceModule embeddedShaderCopyOutputFile ifNotNil: [ :filename |
		spirVModule saveTo: filename.
	].
	
	spirVModuleBlob := SLVMGlobalVariable module: ssaModule name: nil valueType: (SLVMArrayType baseType: SLVMType ucharType elements: spirVModuleBlobData size) storage: SLVMType genericStorage.
	spirVModuleBlob
		readOnly: true;
		initialValue: (SLVMConstant array: spirVModuleBlob valueType blob: spirVModuleBlobData).
	
	spirVModuleInfoGlobal := SLVMGlobalVariable module: ssaModule name: nil
		valueType: (self translateType: self compilationTarget shaderModuleInfo)
		storage: SLVMType genericStorage.
	
	shaderEntryPoints do: [ :entryPoint |
		shaderSSAModule highLevelMapToSymbol at: entryPoint ifPresent: [:shaderEntryPointName |
			self setEmbeddedShaderEntryPoint: entryPoint withName: shaderEntryPointName infoWithModuleInfo: spirVModuleInfoGlobal
		].
	].

	spirVModuleInfoGlobal initialValue: (
		self translateLiteralValue: (
			self compilationTarget shaderModuleInfo defaultValue
				setField: #blobSize value: spirVModuleBlobData size;
				setField: #blobStartPointer value: spirVModuleBlob)
		ofType: self compilationTarget shaderModuleInfo).

	^ spirVModuleInfoGlobal
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateFinalizationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable [
	| valueType globalDtorFunctionType dtor |
	globalVariable needsDestructor ifFalse: [ ^ self ].
	
	valueType := globalVariable valueType.
	self assert: valueType hasTrivialFinalization not.
	globalDtorFunctionType := self compilationTarget voidType => self compilationTarget voidType.

	dtor := self translateCompilerGeneratedMethodNamed: nil functionType: globalDtorFunctionType
		at: globalVariable definitionNode
		with: [:ssaFunction :builder :functionCodeGenerator |
		builder
			call: (self translateProgramEntity: valueType finalizeMethod) ssaValue arguments: { ssaGlobalVariable };
			returnVoid
	].

	(self validConstructionRecordFor: ssaGlobalVariable priority: (globalVariable constructionPriority ifNil: [self compilationTarget normalConstructorPriority]))
		destructor: dtor
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> generateGlobalConstructionSetupMethods [
	| sortedConstructionRecords |
	constructionRecords ifEmpty: [ ^ self ].
	sortedConstructionRecords := constructionRecords sorted: [ :a :b | a priority < b priority ].
	(self groupConstructionRecordsByPriority: sortedConstructionRecords) do: [ :eachGroup |
		self generateGlobalConstructionSetupMethods: eachGroup
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> generateGlobalConstructionSetupMethods: records [
	| globalCtor builder atExit atExitArgumentType |
	records ifEmpty: [ ^ self ].
	globalCtor := SLVMFunction module: ssaModule name: nil functionType: (SLVMFunctionType arguments: #() returnType: SLVMType voidType).
	
	builder := SLVMBuilder on: globalCtor.
	builder newBasicBlockHere: #entry.
	self isEmittingDebugInformation ifTrue: [
		globalCtor
			debugInformation: (self debugInformationTranslator createForModuleStaticConstructorSetup: self compilationTarget voidType => self compilationTarget voidType);
			debugSourceLocation: (self convertDebugPosition: self validSourcePosition).
			
		builder pushDebugSourcePosition: (self convertDebugPosition: self validSourcePosition scope: nil)
	].

	atExit := self sysmelAtExitFunction.
	atExitArgumentType := atExit type baseType arguments first.
	
	records do: [ :each |
		each constructor ifNotNil: [ :ctor |
			builder call: ctor arguments: #()
		].
		each destructor ifNotNil: [ :dtor |
			builder call: atExit arguments: { SLVMConstant pointer: dtor castTo: atExitArgumentType }
		].
	].
	
	builder returnVoid.
	ssaModule addGlobal: nil constructor: globalCtor priority: records first priority
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateGlobalField: field forDescriptorSet: set binding: binding [
	| globalName valueType globalStorage structureKind ssaValueType ssaGlobal |
	globalName := self newSymbolNameMangler mangleProgramEntityName: field
		descriptorSet: set descriptorBinding: binding.

	valueType := field valueType.
	globalStorage := SLVMType uniformConstantStorage.
	ssaValueType := nil.
	valueType isPointerLikeValueType ifTrue: [ 
		self assert: (#(uniformBuffer storageBuffer) includes: valueType addressSpace).
		globalStorage := SLVMType uniformStorage.
		structureKind := (valueType addressSpace == #uniformBuffer)
			ifTrue: [ SLVMStructureType blockKind ]
			ifFalse: [ SLVMStructureType bufferBlockKind ].
		ssaValueType := self translateStructureType: valueType baseType withKind: structureKind.
	] ifFalse: [
		ssaValueType := self translateType: valueType
	].

	ssaGlobal := SLVMGlobalVariable module: ssaModule name: globalName valueType: ssaValueType storage: globalStorage.
	ssaGlobal
		propertyAt: #set put: set;
		propertyAt: #binding put: binding.
	^ ssaGlobal
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateGlobalField: field forShader: shaderStage storage: storage [
	| globalName ssaValueType ssaGlobal location |
	globalName := self newSymbolNameMangler mangleProgramEntityName: field
		suffixes: {shaderStage . storage}.

	ssaValueType := self translateType: field valueType.
	
	location := field location.
	field intrinsic ifNotNil: [ :instricName |
		location := ShaderBuiltInLocationMap at: {shaderStage . instricName}.
	].

	ssaGlobal := SLVMGlobalVariable module: ssaModule name: globalName valueType: ssaValueType storage: storage.
	location ifNotNil: [
		ssaGlobal propertyAt: #location put: location.
	].
	^ ssaGlobal
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateGlobalField: field forSharedStorageWithType: storageType [
	| globalName valueType ssaValueType ssaGlobal |
	globalName := self newSymbolNameMangler mangleProgramEntityName: field
		suffixes: {storageType}.

	valueType := field valueType.
	ssaValueType := self translateType: valueType.

	ssaGlobal := SLVMGlobalVariable module: ssaModule name: globalName valueType: ssaValueType storage: storageType.
	^ ssaGlobal
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateGlobalFieldForPushConstants: field [
	| globalName valueType globalStorage structureKind ssaValueType ssaGlobal |
	globalName := self newSymbolNameMangler mangleProgramEntityName: field
		suffixes: {#pushConstants}.

	valueType := field valueType.
	globalStorage := SLVMType pushConstantStorage.
	structureKind := SLVMStructureType blockKind.
	ssaValueType := self translateStructureType: valueType baseType withKind: structureKind.

	ssaGlobal := SLVMGlobalVariable module: ssaModule name: globalName valueType: ssaValueType storage: globalStorage.
	^ ssaGlobal
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateIdentityHash [
	^ (identityHashRandomGenerator nextInt: (1<<32) + 1) - 1 
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateInitializationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable [
	| globalCtorFunctionType ctor valueType |
	globalVariable needsConstructor ifFalse: [ ^ self ].
	
	valueType := globalVariable valueType.
	globalCtorFunctionType := self compilationTarget voidType => self compilationTarget voidType.
	
	globalVariable initialValueKind = #default ifTrue: [
		ctor := self translateCompilerGeneratedMethodNamed: nil functionType: globalCtorFunctionType
			at: globalVariable definitionNode
			with: [:ssaFunction :builder :functionCodeGenerator |
			valueType hasTrivialInitialization ifFalse: [ 
				builder call: (self translateProgramEntity: valueType initializeMethod) ssaValue arguments: { ssaGlobalVariable }
			].
		
			builder returnVoid
		]
	].

	(#(move copy) includes: globalVariable initialValueKind) ifTrue: [
		self assert: globalVariable initialValueFunclet isNotNil.
		ctor := self translateCompilerGeneratedMethodNamed: nil functionType: globalCtorFunctionType
			at: globalVariable definitionNode
			with: [ :ssaFunction :builder :functionCodeGenerator |
			| funcletValue |
			self isEmittingDebugInformation ifTrue: [
				ssaFunction debugInformation: (SLVMDebugSubprogram new
					isLocal: true;
					isDefinition: true;
					type: (self translateDebugType: globalCtorFunctionType);
					yourself).
				(self translateProgramEntityDebugInformation: globalVariable initialValueFunclet)
					parentScope: ssaFunction debugInformation
			].
		
			funcletValue := functionCodeGenerator generateFuncletValue: globalVariable initialValueFunclet withArguments: #().

			functionCodeGenerator generateVariable: ssaGlobalVariable withValueType: valueType initializationWithValue: funcletValue initialValueKind: globalVariable initialValueKind.
			
			builder returnVoid
		]
	].

	ctor ifNil: [ 
		self error: 'Unsupported global initialization kind'	
	].

	(self validConstructionRecordFor: ssaGlobalVariable priority: (globalVariable constructionPriority ifNil: [self compilationTarget normalConstructorPriority]))
		constructor: ctor
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateNonInlineLiteralValue: nonInlineLiteral [
	| codeGeneratioValue |
	nonInlineLiteral codeGenerationValue ifNotNil: [ ^ self ].
	
	codeGeneratioValue := self slvmCompilationTarget objectModel convertDynamicLiteralToConstant: nonInlineLiteral literalValue.
	codeGeneratioValue ifNil: [ 
		codeGeneratioValue := self slvmCompilationTarget objectModel createNonInlineLiteralConstant: nonInlineLiteral literalValue withCodeGenerator: nil.
		self halt.
	].

	ssaModule importType: codeGeneratioValue type fromModule: nil.
	nonInlineLiteral codeGenerationValue: codeGeneratioValue
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generatedNameForAnynomousEntity: programEntity [
	| result |
	generatedNameTable at: programEntity ifPresent: [ :existent | ^ existent ].
	
	programEntity isVTablePointerField ifTrue: [
		result := '__vtable' , programEntity slotIndex asString.
		generatedNameTable at: programEntity put: result.
		^ result.
	].
	programEntity isCompileTimeVariable ifTrue: [
		result := '__compileTimeVariable' , anonSymbolCount asString.
		anonSymbolCount := anonSymbolCount + 1.
		generatedNameTable at: programEntity put: result.
		^ result.
	].
	self assert: programEntity isTemplateInstance not.

	result := '___anon' , anonSymbolCount asString , '___'.
	anonSymbolCount := anonSymbolCount + 1.
	generatedNameTable at: programEntity put: result.
	^ result
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getField: field asSharedStorageWithType: storageType [
	^ convertedDescriptorSetBindings at: {storageType . field} ifAbsentPut: [ 
		self generateGlobalField: field forSharedStorageWithType: storageType
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getField: field fromDescriptorSet: aggregateValue [
	| set binding |
	set := aggregateValue setIndex.
	binding := field asDescriptorSetBinding.
	^ convertedDescriptorSetBindings at: {set . binding . field} ifAbsentPut: [ 
		self generateGlobalField: field forDescriptorSet: set binding: binding
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getFieldAsPushConstantReference: field [
	^ convertedDescriptorSetBindings at: {#pushConstant . field} ifAbsentPut: [ 
		self generateGlobalFieldForPushConstants: field
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> getOrCreateDynamicFunctionCallAdapterFor: functionType [
	| adapterFunctionType dynamicObjectType unwrappedArguments callResultType convertedResult |
	dynamicObjectType := self compilationTarget dynamicObjectType.
	adapterFunctionType := self compilationTarget
		functionTypeWithArguments: {functionType pointer} , (functionType argumentTypes collect: [ :arg | dynamicObjectType ])
		returnType: dynamicObjectType.
	^ dynamicFunctionCallsAdapters at: adapterFunctionType ifAbsentPut: [ 
		self generateAnonCompilerGeneratedMethodWithType: adapterFunctionType allowGC: true
		debugInformationWith: [ self debugInformationTranslator createForTrampolineWithFunctionType: adapterFunctionType ]
		with: [:ssaFunction :builder :functionCodeGenerator |
			| calledFunction result |
			"Unwrap the arguments."
			calledFunction := ssaFunction arguments first.
			unwrappedArguments := ssaFunction arguments allButFirst collectWithIndex: [ :argValue :argIndex |
				functionCodeGenerator unwrapDynamicObject: argValue withType: dynamicObjectType intoValueOfType: (functionType argumentTypes at: argIndex)
			].
		
			"Generate the call."
			result := functionCodeGenerator generateCall: calledFunction arguments: unwrappedArguments calledFunctionType: functionType.
			
			"Compute the actual result type."
			callResultType := functionType returnType.
		
			"Wrap the result."
			convertedResult := functionCodeGenerator wrapValue: result withType: callResultType intoDynamicObjectWithType: dynamicObjectType.
			
			"Finalize the temporary result."
			functionType returnType hasTrivialFinalization ifFalse: [
				self flag: 'FIXME: Make this finalization implicit by using clean-up actions.'.
				functionCodeGenerator generateVariable: result finalizationForValueType: functionType returnType
			].
			
			builder return: convertedResult
		]
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getOrCreateFalseLiteralValue [
	^ SLVMConstant pointer: (self getOrCreateSpecialSingletonNamed: #false withClass: self compilationTarget managedObjectModel falseClass)
		castTo: (self translateType: self compilationTarget dynamicObjectType)
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> getOrCreateNativeClosureTypeInfoFor: closureFunctionType withCaptures: capturedTypes for: prototype [
	| typeInfoClass typeInfoObjectInstance instanceSize instanceAlignment |
	typeInfoClass := self compilationTarget typeInformationClass.
	typeInfoClass ifNil: [ ^ nil ].
	
	instanceSize := prototype type size.
	instanceAlignment := prototype type alignment.
	
	^ nativeClosureTypeInfos at: { closureFunctionType . capturedTypes} ifAbsentPut: [
		| needsCopyConstructor needsMoveConstructor needsFinalizer ssaClosureTypeInfo
		vtableEntryType vtableEntries vtableType vtable ssaTypeInfoType |
		typeInfoObjectInstance := typeInfoClass makeInstance. 
		typeInfoObjectInstance setField: #instanceDataSize value: instanceSize.
		typeInfoObjectInstance setField: #instanceDataAlignment value: instanceAlignment.

		needsCopyConstructor := false.
		needsMoveConstructor := false.
		needsFinalizer := false.
		capturedTypes do: [ :each |
			each hasTrivialInitializationCopyingFrom ifFalse: [
				needsCopyConstructor := true.
			].
			each hasTrivialInitializationMovingFrom ifFalse: [
				needsMoveConstructor := true.
			].
			each hasTrivialFinalization ifFalse: [
				needsFinalizer := true.
			].
		].
		
		needsCopyConstructor ifTrue: [
			self halt
		].
		needsMoveConstructor ifTrue: [
			self halt
		].
		needsFinalizer ifTrue: [
			self halt
		].

		ssaTypeInfoType := self translateType: typeInfoClass.
		ssaTypeInfoType isPointerType ifTrue: [ ssaTypeInfoType := ssaTypeInfoType baseType ].
		ssaClosureTypeInfo := SLVMGlobalVariable module: ssaModule name: nil valueType: ssaTypeInfoType storage: (typeInfoClass hasGarbageCollectedAddressSpace ifTrue: [SLVMType gcStorage] ifFalse: [SLVMType genericStorage]).
		typeInfoClass isGarbageCollectedType ifTrue: [
			ssaClosureTypeInfo initialValue: (self literalValueGenerator translateDynamicObjectInstanceContent: typeInfoObjectInstance).
		] ifFalse: [ 
			ssaClosureTypeInfo initialValue: (self literalValueGenerator translateLiteralValue: typeInfoObjectInstance ofType: typeInfoClass).
		].
		
		vtableEntryType := self slvmCompilationTarget voidPointerType.
		vtableEntries := {
			"Offset" SLVMConstant type: vtableEntryType value: 0.
			"Type info" . SLVMConstant value: ssaClosureTypeInfo bitcast: self slvmCompilationTarget voidPointerType.
		}.
		vtableType := SLVMArrayType baseType: vtableEntryType elements: vtableEntries size.
		vtable := SLVMGlobalVariable module: ssaModule name: nil valueType: vtableType storage:  SLVMType genericStorage.
		vtable initialValue: (SLVMConstant array: vtableType slots: vtableEntries).
		
		SLVMConstant getReference: vtable element: vtableEntries size
	].
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> getOrCreateNativeMethodDispatchTrampolineWithType: messageFunctionType [
	| dynobjectType trampolineFunctionType trampoline |
	dynobjectType := self compilationTarget dynamicObjectType.
	trampolineFunctionType := messageFunctionType prependArguments: {
		"methodFunctionPointer" messageFunctionType pointer . "selector" dynobjectType
	}.
	
	trampoline := self generateAnonCompilerGeneratedMethodWithType: trampolineFunctionType allowGC: true
	debugInformationWith: [ self debugInformationTranslator createForTrampolineWithFunctionType: trampolineFunctionType ]
	with: [:ssaFunction :builder :functionCodeGenerator |
		| calledFunction nativeArguments result |
		trampolineFunctionType returnType isMemoryReturnedType ifTrue: [
			calledFunction := ssaFunction arguments second.
			nativeArguments := {ssaFunction arguments first} , (ssaFunction arguments allButFirst: 3)
		] ifFalse: [
			calledFunction := ssaFunction arguments first.
			nativeArguments := ssaFunction arguments allButFirst: 2
		].
	
		result := builder call: calledFunction arguments: nativeArguments.
		trampolineFunctionType returnType isMemoryReturnedType ifTrue: [ 
			result setSRetPresence
		].
	
		result type isVoidType ifTrue: [
			builder returnVoid
		] ifFalse: [
			builder return: result
		].
	].

	^ SLVMConstant value: trampoline bitcast: self slvmCompilationTarget voidPointerType
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> getOrCreateObjectMethodDispatchTrampolineWithType: messageFunctionType [
	| dynobjectType trampolineFunctionType trampoline runWithInFunctionType |
	dynobjectType := self compilationTarget dynamicObjectType.
	runWithInFunctionType := self compilationTarget functionTypeWithArguments: {
		"self" dynobjectType .
		"run: selector" dynobjectType .
		"with: arguments" dynobjectType .
		"in: receiver" dynobjectType } returnType: dynobjectType.
	messageFunctionType canHaveDynamicMethodWrapper ifFalse: [ 
		^ self slvmCompilationTarget voidPointerType defaultConstant
	].

	trampolineFunctionType := messageFunctionType prependArguments: {
		"methodObject" dynobjectType . "selector" dynobjectType .
	}.
	
	trampoline := objectMethodDispatchTrampolines at: messageFunctionType ifAbsentPut: [
		self generateAnonCompilerGeneratedMethodWithType: trampolineFunctionType allowGC: true
		debugInformationWith: [ self debugInformationTranslator createForTrampolineWithFunctionType: trampolineFunctionType ]
		with: [:ssaFunction :builder :functionCodeGenerator |
			| selector methodObject result receiver unmarshalledArguments marshalledArguments marshalledArgumentsStoragePointer unmarshalledResult |
			trampolineFunctionType returnType isMemoryReturnedType ifTrue: [
				methodObject := ssaFunction arguments second.
				selector := ssaFunction arguments third.
				receiver := ssaFunction arguments fourth.
				unmarshalledArguments := ssaFunction arguments allButFirst: 4
			] ifFalse: [
				methodObject := ssaFunction arguments first.
				selector := ssaFunction arguments second.
				receiver := ssaFunction arguments third.
				unmarshalledArguments := ssaFunction arguments allButFirst: 3
			].

			marshalledArguments := functionCodeGenerator makeDynamicArrayInstanceWithFixedSize: unmarshalledArguments size.
			marshalledArgumentsStoragePointer := builder getReference: marshalledArguments
				element: (builder constInt: marshalledArguments type baseType types size - 1).
			
			unmarshalledArguments doWithIndex: [:nativeArgument :index |
				| wrappedArgument |
				wrappedArgument := functionCodeGenerator wrapValue: nativeArgument withType: (messageFunctionType argumentTypes at: index + 1) intoDynamicObjectWithType: dynobjectType.
				builder store: wrappedArgument in: (builder getReference: marshalledArgumentsStoragePointer element: (builder constInt: index - 1))
			].
		
			result := builder send: (builder addDynamicLiteral: #run:with:in:) returnType: (self translateType: dynobjectType) receiver: methodObject arguments: {selector . marshalledArguments . receiver}.
			result highLevelMessageSendFunctionType: runWithInFunctionType.
		
			messageFunctionType returnType isMemoryReturnedType ifTrue: [ 
				self halt
			] ifFalse: [
				unmarshalledResult := functionCodeGenerator unwrapDynamicObject: result withType: dynobjectType intoValueOfType: messageFunctionType returnType.
			].
	
			ssaFunction functionType returnType isVoidType ifTrue: [
				builder returnVoid
			] ifFalse: [
				builder return: unmarshalledResult
			].
	
			ssaFunction
				addRequiredDynamicLiteral: #trampoline;
				addRequiredDynamicLiteral: nil;
				hasSelectorAndClassBinding: true
		].
	].

	^ SLVMConstant value: trampoline bitcast: self slvmCompilationTarget voidPointerType
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getOrCreateShaderEntryPointInfoFor: concreteMethod [
	^ shaderEntryPointInfoDictionary at: concreteMethod ifAbsentPut: [
		SLVMGlobalVariable module: ssaModule name: nil valueType: (self translateType: self compilationTarget shaderEntryPointInfo) storage: SLVMType genericStorage 
	].
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getOrCreateSpecialSingletonNamed: singletonName withClass: singletonClass [
	| mangledName pointerType ssaPointerType singletonVar importedSSAModule |
	mangledName := self newSymbolNameMangler mangleNestedNameComponents: { self compilationEnvironment coreModule name . #'..s..' . singletonName }.
	pointerType := singletonClass isGCClassType
		ifTrue: [singletonClass]
		ifFalse: [singletonClass pointer].
	ssaPointerType := self translateType: pointerType.

	sourceModule == self compilationEnvironment coreModule ifTrue: [ 
		singletonVar := SLVMGlobalVariable module: ssaModule name: mangledName valueType: ssaPointerType baseType storage: ssaPointerType storage.
		singletonVar makePublic.
		singletonVar unmangledName: singletonName.
		singletonVar initialValue: (self literalValueGenerator translateObject: singletonClass content: singletonClass makeInstance).
	] ifFalse: [
		importedSSAModule := self compilationEnvironment coreModule namedTargetCodeModules at: targetCodeModuleName.
		singletonVar := ssaModule importGlobalValue: (importedSSAModule globalNamed: mangledName) fromModule: importedSSAModule.
	].

	^ singletonVar
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getOrCreateTrueLiteralValue [
	^ SLVMConstant pointer: (self getOrCreateSpecialSingletonNamed: #true withClass: self compilationTarget managedObjectModel trueClass)
		castTo: (self translateType: self compilationTarget dynamicObjectType)
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> getShaderIOField: field storage: storage forStage: specialSemantics [
	^ convertedShaderIOFields at: {field . storage . specialSemantics} ifAbsentPut: [ 
		self generateGlobalField: field forShader: specialSemantics storage: storage
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> gpuTypeMapping [
	self slvmCompilationTarget isGPU ifFalse: [ ^ #() ].
	^ #(
		(gpuSamplerType sampler)
		
		(gpuTexture1DType texture1D)
		(gpuTexture1DArrayType texture1DArray)
		(gpuTexture2DType texture2D)
		(gpuTexture2DArrayType texture2DArray)
		(gpuTexture3DType texture3D)
		(gpuTexture3DArrayType texture3DArray)
		(gpuTextureCubeType textureCube)
		(gpuTextureCubeArrayType textureCubeArray)

		(gpuDepthTexture2DType depthTexture2D)
		(gpuDepthTexture2DArrayType depthTexture2DArray)
		(gpuDepthTextureCubeType depthTextureCube)
		(gpuDepthTextureCubeArrayType depthTextureCubeArray)
	)
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> groupConstructionRecordsByPriority: groups [
	| result currentPriority currentGroup |
	result := OrderedCollection new.
	currentPriority := nil.
	currentGroup := nil.
	groups do: [ :each |
		each priority ~= currentPriority ifTrue: [ 
			currentGroup ifNotNil: [
				result add: currentGroup.
			].
			currentPriority := each priority.
			currentGroup := OrderedCollection new
		].
		currentGroup add: each.
	].

	currentGroup ifNotNil: [
		result add: currentGroup.
	].
	^ result
]

{ #category : #testing }
MbndSlovimCodeModuleGenerator >> hasExceptions [
	self compilationTarget isGPU ifTrue: [ ^ false ].
	^ sourceModule hasExceptions
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> importTranslatedProgramEntity: externalProgramEntity [
	| importedModule importedSSAModule programEntitySymbol externalProgramEntityValue |
	importedModule := externalProgramEntity module.
	importedSSAModule := importedModule namedTargetCodeModules at: targetCodeModuleName.
	programEntitySymbol := importedSSAModule highLevelMapToSymbol at: externalProgramEntity ifAbsent: [
		"The symbol may not be found because it could not be needed. In those cases, translate it into a null constant."
		externalProgramEntity isAbstractVirtualMethod ifTrue: [
			^ (self translateType: externalProgramEntity type pointer) defaultConstant
		].

		self compilationEnvironment hasRuntimeTypeInformation ifFalse: [	
			^ (self translateType: externalProgramEntity type) defaultConstant
		].

		(externalProgramEntity isMbndType and: [externalProgramEntity isModuleSpecificType not]) ifTrue: [
			^ nil
		].
	
		(externalProgramEntity parent isNotNil and: [externalProgramEntity parent isMbndType and: [externalProgramEntity parent isModuleSpecificType not]]) ifTrue: [
			^ nil
		].
		self error: 'Compiled bug. Exported program entity {1} without an associated exported symbol.' format: { externalProgramEntity asString }
	].
	ssaModule globalNamed: programEntitySymbol ifPresent: [ :alreadyImported |
		^ alreadyImported
	].

	externalProgramEntityValue := importedSSAModule globalNamed: programEntitySymbol.
	^ ssaModule importGlobalValue: externalProgramEntityValue fromModule: ssaModule
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> indexOutOfBoundsRaiseFunction [
	^ indexOutOfBoundsRaiseFunction ifNil: [
		self compilationTarget indexOutOfBoundsRaiseFunction ifNotNil: [ :function |
			indexOutOfBoundsRaiseFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			indexOutOfBoundsRaiseFunction := SLVMFunction module: ssaModule
				name: #__sysmel_indexOutOfBoundsRaiseFunction
				functionType: (SLVMFunctionType arguments: {self slvmCompilationTarget intPointer . self slvmCompilationTarget intPointer} returnType: self slvmCompilationTarget void)

		]
	]
]

{ #category : #initialization }
MbndSlovimCodeModuleGenerator >> initialize [
	super initialize.
	translatedProgramEntities := Dictionary new.
	anonSymbolCount := 0.
	debugSourceFileDictionary := Dictionary new.
	debugLocationDictionary := Dictionary new.
	identityHashRandomGenerator := Random seed: 0.
	intrinsicConstantBuiltInFunctionCache := Dictionary new.
	convertedDescriptorSetBindings := Dictionary new.
	convertedShaderIOFields := Dictionary new.
	structuresWithAdditionalKinds := Dictionary new.
	generatedNameTable := IdentityDictionary new.
	dynamicFunctionCallsAdapters := IdentityDictionary new.
	objectMethodDispatchTrampolines := IdentityDictionary new.
	shaderEntryPointInfoDictionary := IdentityDictionary new.
	gpuUsableProgramEntitites := OrderedCollection new.
	nativeClosureTypeInfos := Dictionary new.
	nativeShaderEntryPoints := Dictionary new.
	
	constructionRecordDictionary := Dictionary new.
	constructionRecords := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> intrinsicConstantBuiltInFunction: intrinsicName withSSAFunctionType: ssaFunctionType [
	^ intrinsicConstantBuiltInFunctionCache at: { intrinsicName . ssaFunctionType } ifAbsentPut: [ 
		SLVMConstantBuiltInFunction pointerSize: self slvmCompilationTarget pointerSize
			name: intrinsicName
			functionType: ssaFunctionType
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> intrinsicConstantBuiltInFunction: intrinsicName withType: functionType [
	| ssaFunctionType |
	ssaFunctionType := self translateType: functionType.
	^ self intrinsicConstantBuiltInFunction: intrinsicName withSSAFunctionType: ssaFunctionType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> isEmittingDebugInformation [
	^ self slvmCompilationTarget emittingDebugInformation
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> landingPathResultType [
	^ landingPathResultType ifNil: [
		landingPathResultType := SLVMStructureType name: nil
			types: { self slvmCompilationTarget voidPointerType . self slvmCompilationTarget int }
			kind: SLVMStructureType genericKind names: #(exception selector)
		]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> literalValueGenerator [
	^ MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityName: programEntity [
	^ self newSymbolNameMangler mangleProgramEntityName: programEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> newSymbolNameMangler [
	^ self symbolNameManglerPrototype copy
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> nonLocalReturnCatchFunction [
	^ nonLocalReturnCatchFunction ifNil: [
		self compilationTarget nonLocalReturnCatchFunction ifNotNil: [ :function |
			nonLocalReturnCatchFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			nonLocalReturnCatchFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_nonLocalReturnCatch
				functionType: ((SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: self slvmCompilationTarget void)
					variadic: true
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> nonLocalReturnRaiseFunction [
	^ nonLocalReturnRaiseFunction ifNil: [
		self compilationTarget nonLocalReturnRaiseFunction ifNotNil: [ :function |
			nonLocalReturnRaiseFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			nonLocalReturnRaiseFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_nonLocalReturnRaise
				functionType: ((SLVMFunctionType arguments: { self slvmCompilationTarget voidPointerType } returnType: self slvmCompilationTarget void)
					variadic: true
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> patternMatchingFailureRaiseFunction [
	^ patternMatchingFailureRaiseFunction ifNil: [
		self compilationTarget patternMatchingFailureRaiseFunction ifNotNil: [ :function |
			patternMatchingFailureRaiseFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			patternMatchingFailureRaiseFunction := SLVMFunction module: ssaModule
				name: #__sysmel_patternMatchingFailureRaise
				functionType: (SLVMFunctionType arguments: #() returnType: self slvmCompilationTarget void)

		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> personalityFunction [
	^ personalityFunction ifNil: [
		self compilationTarget personalityFunction ifNotNil: [ 
			personalityFunction := (self translateProgramEntity: self compilationTarget personalityFunction) ssaValue
		] ifNil: [
			personalityFunction := SLVMFunction module: ssaModule
				name: #__sysmel_eh_personality
				functionType: ((SLVMFunctionType arguments: #() returnType: SLVMType voidType)
					variadic: true
				)
		]
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> pureVirtualFunctionConstantWithType: ssaFunctionType [
	^ ssaFunctionType defaultConstant
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> sampleTextureExplicitDerivativesFunction [
	^ sampleTextureExplicitDerivativesFunction ifNil: [
		self compilationTarget personalityFunction ifNotNil: [ 
			sampleTextureExplicitDerivativesFunction := (self translateProgramEntity: self compilationTarget sampleTextureExplicitLodFunction) ssaValue
		] ifNil: [
			sampleTextureExplicitDerivativesFunction := SLVMFunction module: ssaModule
				name: #__sysmel_sampleTextureExplicitDerivatives
				functionType: ((SLVMFunctionType arguments: {
					"Sampler" self slvmCompilationTarget voidPointerType .
					"Texture" self slvmCompilationTarget voidPointerType .
					"Texcoord" SLVMType float4Type .
					"dtdx" SLVMType float4Type .
					"dtdy" SLVMType float4Type} returnType: SLVMType float4Type)
					variadic: true
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> sampleTextureExplicitLodFunction [
	^ sampleTextureExplicitLodFunction ifNil: [
		self compilationTarget personalityFunction ifNotNil: [ 
			sampleTextureExplicitLodFunction := (self translateProgramEntity: self compilationTarget sampleTextureExplicitLodFunction) ssaValue
		] ifNil: [
			sampleTextureExplicitLodFunction := SLVMFunction module: ssaModule
				name: #__sysmel_sampleTextureExplicitLod
				functionType: ((SLVMFunctionType arguments: {
					"Sampler" self slvmCompilationTarget voidPointerType .
					"Texture" self slvmCompilationTarget voidPointerType .
					"Texcoord" SLVMType float4Type .
					"Lod" SLVMType floatType} returnType: SLVMType float4Type)
					variadic: true
				)
		]
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> sampleTextureImplicitLodFunction [
	^ sampleTextureImplicitLodFunction ifNil: [
		self compilationTarget personalityFunction ifNotNil: [ 
			sampleTextureImplicitLodFunction := (self translateProgramEntity: self compilationTarget sampleTextureImplicitLodFunction) ssaValue
		] ifNil: [
			sampleTextureImplicitLodFunction := SLVMFunction module: ssaModule
				name: #__sysmel_sampleTextureImplicitLod
				functionType: ((SLVMFunctionType arguments: {
					"Sampler" self slvmCompilationTarget voidPointerType .
					"Texture" self slvmCompilationTarget voidPointerType .
					"Texcoord" SLVMType float4Type } returnType: SLVMType float4Type)
					variadic: true
				)
		]
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> sanitizeStructureFieldType: fieldType [
	self slvmCompilationTarget isGPU ifTrue: [ 
		fieldType isPointerType ifTrue: [
			^ self slvmCompilationTarget pointerSize = 4
				ifTrue: [ self slvmCompilationTarget int32 ]
				ifFalse: [ SLVMVectorType baseType: self slvmCompilationTarget int32 elements: 2 ].
		]
	].

	^ self sanitizeValueTypeForMemory: fieldType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> sanitizeValue: value withExpectedType: expectedType [
	self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
		(value type isVectorType and: [expectedType isVectorType]) ifTrue: [ 
			(expectedType baseType isBooleanType and: [ value type baseType isIntegerType ]) ifTrue: [ 
				self halt.
			].
	
			(expectedType baseType isIntegerType and: [ value type baseType isBooleanType ]) ifTrue: [ 
				self halt.
			].
		].
	
		(expectedType isBooleanType and: [ value type isIntegerType ]) ifTrue: [
			self assert: value isConstantValue.
			^ SLVMConstant type: expectedType value: value value asInteger ~= 0
		].
	
		(expectedType isIntegerType and: [ value type isBooleanType ]) ifTrue: [ 
			self assert: value isConstantValue.
			^ SLVMConstant type: expectedType value: value value asBit
		].
	].

	^ value
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> sanitizeValueTypeForMemory: valueType [
	self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [
		valueType isBooleanType ifTrue: [ 
			^ self slvmCompilationTarget uint8
		].

		(valueType isVectorType and: [ valueType baseType isBooleanType ]) ifTrue: [ 
			^ SLVMVectorType baseType: self slvmCompilationTarget uint8 elements: valueType elements
		].
	].

	^ valueType
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> setEmbeddedShaderEntryPoint: entryPoint withName: symbolName infoWithModuleInfo: shaderModuleInfoGlobal [
	| entryPointInfo entryPointInfoData |
	entryPointInfo := self getOrCreateShaderEntryPointInfoFor: entryPoint.
	entryPointInfoData := self compilationTarget shaderEntryPointInfo defaultValue.
	entryPointInfoData
		setField: #moduleInfo value: shaderModuleInfoGlobal;
		setField: #entryPointSymbol value: (SLVMConstant cstringPointer: symbolName for: self compilationTarget);
		setField: #nativeShaderEntryPoint value: (SLVMConstant pointer: (nativeShaderEntryPoints at: entryPoint) castTo: (self translateType: self compilationTarget voidType pointer));
		setField: #stageType value: (ShaderTypeToStageType at: entryPoint specialSemantics).
		
	entryPoint specialSemantics = #compute ifTrue: [
		| localSize |
		localSize := entryPoint computeShaderLocalSize.
		entryPointInfoData
			setField: #localSizeX value: localSize first;
			setField: #localSizeY value: localSize second;
			setField: #localSizeZ value: localSize third
	].

	entryPointInfo
		initialValue: (self translateLiteralValue: entryPointInfoData ofType: self compilationTarget shaderEntryPointInfo)
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> setProgramEntity: programEntity ssaValue: ssaValue [
	self setProgramEntity: programEntity translation: (MbndSlovimTranslatedProgramEntitySSAValue new
		programEntity: programEntity;
		ssaValue: ssaValue;
		yourself)
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> setProgramEntity: programEntity translation: translation [
	translatedProgramEntities at: programEntity put: translation.
	^ translation
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> setupGCStrategyFor: ssaFunction generatedFrom: functionMethod [
	sourceModule hasGarbageCollectionStackMap ifFalse: [ ^ self ].
	(functionMethod hasPragmaNamed: #nogc) ifTrue: [ ^ self ].
	ssaFunction gcStrategy: #sysmel
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> shouldGenerateRTTIForProgramEntity: programEntity withSSAType: ssaProgramEntityInfoType [
	ssaProgramEntityInfoType baseType isVoidType ifTrue: [ ^ false ].
	self slvmCompilationTarget isGPU ifTrue: [ ^ false ].
	sourceModule hasRuntimeTypeInformation ifTrue: [ ^ true ].
	
	(programEntity isMbndType and: [programEntity isAbstractClassType]) ifTrue: [
		(sourceModule hasExceptions and: [programEntity isThrowable]) ifTrue: [ ^ true ].
		programEntity hasRequiredRTTI ifTrue: [ ^ true ].
	].

	^ false
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> slvmCompilationTarget [
	^ self compilationTarget slvmCompilationTarget
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> sourceModule [
	^ sourceModule
]

{ #category : #initialization }
MbndSlovimCodeModuleGenerator >> ssaModule [
	^ ssaModule
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> storeNativeShader: functionMethod outputsOfType: outputMessageType
from: outputStorage into: ioInterface
outputsField: outputsField outputsLocationsField: outputsLocationsField
with: builder [
	outputMessageType slotLayout slots do: [ :slot |
		| slotField outputField |
		self assert: slot fields size = 1.
		slotField := slot fields first.
		outputField := nil.
		
		slotField intrinsic ifNotNil: [ :intrinsicName |
			| intrisicField |
			intrisicField := outputsField valueType findFieldWithIntrinsicNamed: intrinsicName.
			intrisicField ifNotNil: [
				outputField := builder getPointer: ioInterface element: {
					builder constInt: 0.
					builder constInt: outputsField slotIndex.
					builder constInt: intrisicField slotIndex.
				}.
			].
		].
		slotField location ifNotNil: [ :location |
			(outputsLocationsField isNotNil and: [
			location isInteger and: [
			0 <= location and: [
			location < outputsLocationsField valueType elements ]]]) ifTrue: [
				outputField := builder getPointer: ioInterface element: {
					builder constInt: 0.
					builder constInt: outputsField slotIndex.
					builder constInt: outputsLocationsField slotIndex.
					builder constInt: location.
				}.
	 		]
		].
	
		outputField ifNotNil: [ 
			| outputStorageField |
			outputStorageField := builder getReference: outputStorage element: (builder constInt: slotField slotIndex).
	
			outputField type baseType ~= outputStorageField type baseType ifTrue: [ 
				outputField := builder bitCast: outputField target: outputStorageField type
			].

			builder store: (builder load: outputStorageField) in: outputField
		].
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> storeShader: functionMethod outputsOfType: outputMessageType from: inputFetchedLocation with: builder [
	| slotField outputGlobal |
	self assert: outputMessageType isAggregateType.
	outputMessageType slotLayout slots do: [ :slot |
		self assert: slot fields size = 1.
		slotField := slot fields first.
		outputGlobal := self getShaderIOField: slotField storage: SLVMType outputStorage forStage: functionMethod specialSemantics.
		builder store: (builder load: (builder getReference: inputFetchedLocation element: (builder constInt: slotField slotIndex)))
			in: outputGlobal
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> symbolNameManglerPrototype [
	^ symbolNameManglerPrototype ifNil: [
		symbolNameManglerPrototype := MbndSlovimSymbolNameMangler new
			compilationTarget: self compilationTarget;
			codeModuleGenerator: self;
			yourself
	]
]

{ #category : #'runtime functions' }
MbndSlovimCodeModuleGenerator >> sysmelAtExitFunction [
	^ sysmelAtExitFunction ifNil: [
		self compilationTarget sysmelAtExitFunction ifNotNil: [ :function |
			sysmelAtExitFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			sysmelAtExitFunction := SLVMFunction module: ssaModule
				name: #__sysmel_atexit
				functionType: ((SLVMFunctionType arguments: {self slvmCompilationTarget voidPointerType} returnType: SLVMType voidType)
					variadic: true
				)
		]
	]
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> targetCodeModuleName [
	^ targetCodeModuleName
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateCompilerGeneratedMethod: generatedMethod with: codeGenerationBlock [
	| ssaFunctionType csymbol ssaFunction unmangledName |
	ssaFunctionType := self translateType: generatedMethod type.
	
	csymbol := self csymbolForProgramEntity: generatedMethod.
	unmangledName := self unmangledNameForProgramEntity: generatedMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	ssaFunction unmangledName: unmangledName.
	ssaModule addHighLevelEntity: generatedMethod mapToGlobalValue: ssaFunction.
	
	generatedMethod parent areSyntheticMethodsInternal ifTrue: [ ssaFunction makePrivate ].
	
	self setProgramEntity: generatedMethod ssaValue: ssaFunction.

	self isEmittingDebugInformation ifTrue: [
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: generatedMethod);
			debugSourceLocation: (self convertDebugPosition: generatedMethod validSourcePosition asActualSourcePosition)
	].

	self flag: 'TODO: Support the correct linkage/visibility.'.
	ssaFunction makePublic.
	generatedMethod isFunclet ifTrue: [
		ssaFunction makePrivate
	] ifFalse: [
		generatedMethod parent areSyntheticMethodsInternal ifTrue: [ ssaFunction makeWeakODR ]
	].
	self setupGCStrategyFor: ssaFunction generatedFrom: generatedMethod.
	
	self createFunctionCodeGenerator
		buildSSAFunction: ssaFunction definitionWithMethod: generatedMethod
			withCodeGenerationBlock: codeGenerationBlock.

	^ ssaFunction
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateCompilerGeneratedMethodNamed: name functionType: functionType at: sourcePosition with: codeGenerationBlock [
	| ssaFunctionType ssaFunction |
	ssaFunctionType := self translateType: functionType.
	
	ssaFunction := SLVMFunction module: ssaModule name: name functionType: ssaFunctionType.
	ssaFunction unmangledName: name.
	
	self isEmittingDebugInformation ifTrue: [
		ssaFunction
			debugType: (self translateDebugType: functionType);
			debugSourceLocation: (self convertDebugPosition: sourcePosition asActualSourcePosition)
	].

	name ifNil: [ ssaFunction makePrivate ]
		ifNotNil: [ ssaFunction makePublic ].
		
	self createFunctionCodeGenerator
		buildSSAFunction: ssaFunction at: sourcePosition withCodeGenerationBlock: codeGenerationBlock.
			
	^ ssaFunction.
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateDebugType: aType [
	^ self debugInformationTranslator translateDebugType: aType
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateDynamicObjectInstanceContent: dynamicObject [
	^ self literalValueGenerator translateDynamicObjectInstanceContent: dynamicObject
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateLiteralValue: literalValue ofType: literalType [
	^ self literalValueGenerator translateLiteralValue: literalValue ofType: literalType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateModuleLevelInlineAssembly: inlineAssembly [
	ssaModule addArchitecture: inlineAssembly architecture language: inlineAssembly dialect inlineAssembly: inlineAssembly assembly
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntity: programEntity [
	^ translatedProgramEntities at: programEntity ifAbsent: [
		| ssaValue |
		self assert: programEntity module isNotNil.
		(programEntity isModuleSpecializedProgramEntity not and: [programEntity module ~~ sourceModule]) ifTrue: [ 
			ssaValue := self importTranslatedProgramEntity: programEntity.
			ssaValue ifNotNil: [ 
				self setProgramEntity: programEntity ssaValue: ssaValue
			].
		].
	
		ssaValue ifNil: [ 
			ssaValue := programEntity accept: self.
			translatedProgramEntities at: programEntity ifAbsent: [
				self setProgramEntity: programEntity ssaValue: ssaValue
			].
		].
	
		translatedProgramEntities at: programEntity 
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntityChildren: programEntity [
	programEntity children do: [ :child |
		self translateProgramEntity: child
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateProgramEntityDebugInformation: aProgramEntity [
	aProgramEntity isMbndType ifTrue: [ ^ self translateDebugType: aProgramEntity ].
	^ self debugInformationTranslator translateProgramEntityDebugInformation: aProgramEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntityInformationData: programEntity [
	| ssaProgramEntityInfoType ssaProgramEntityInfo programEntityType |
	programEntityType := programEntity type.
	ssaProgramEntityInfoType := self translateType: programEntityType.
	self assert: ssaProgramEntityInfoType isPointerType.
	
	(self shouldGenerateRTTIForProgramEntity: programEntity withSSAType: ssaProgramEntityInfoType) ifFalse: [
		self assert: (programEntity isMbndType not or: [programEntity isGarbageCollectedType not]).
		ssaProgramEntityInfo := SLVMConstant nullPointer: ssaProgramEntityInfoType.
		self setProgramEntity: programEntity ssaValue: ssaProgramEntityInfo.
		^ ssaProgramEntityInfo
	].

	ssaProgramEntityInfo := SLVMGlobalVariable module: ssaModule name: (self newSymbolNameMangler mangleProgramEntityInfo: programEntity) valueType: ssaProgramEntityInfoType baseType storage: ssaProgramEntityInfoType storage.
	self setProgramEntity: programEntity ssaValue: ssaProgramEntityInfo.
	ssaModule addHighLevelEntity: programEntity mapToGlobalValue: ssaProgramEntityInfo.
	
	(programEntity isMbndType and: [
		programEntity isSpecialStructureType or:
		[ programEntity isSystemProvidedTypeTemplateInstanceMainChild ] ]) ifTrue: [
		ssaProgramEntityInfo makeWeakODR
	].
	
	ssaProgramEntityInfo initialValue: (self literalValueGenerator translateObject: programEntityType content: programEntity programEntityInformationData).

	^ ssaProgramEntityInfo
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntityMetaChildren: programEntity [
	programEntity children do: [ :child |
		self translateProgramEntity: child
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateStructureType: type withKind: structureKind [
	| ssaStructureType |
	ssaStructureType := self translateType: type.
	^ structuresWithAdditionalKinds at: { ssaStructureType . structureKind } ifAbsentPut: [ 
		| newStructureType |
		newStructureType := ssaStructureType copy
			name: (ssaStructureType name , '__ ', structureKind) asSymbol;
			kind: structureKind;
			yourself.
		ssaModule addStructure: newStructureType.
		newStructureType
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateType: aType [
	^ self typeTranslator translateType: aType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateTypeInfoDefinition: type [
	^ self translateProgramEntityInformationData: type
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateTypes: aType [
	^ self typeTranslator translateTypes: aType
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> typeTranslator [
	^ typeTranslator ifNil: [ typeTranslator := MbndSlovimTypeTranslator new codeModuleGenerator: self ]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> unmangledNameForProgramEntity: programEntity [
	^ ByteString streamContents: [ :out |
		self unmangledNameForProgramEntity: programEntity into: out
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> unmangledNameForProgramEntity: programEntity into: out [
	programEntity isMbndType ifTrue: [ 
		(programEntity isCoreBasicType or: [programEntity isSystemProvidedTypeTemplateInstanceMainChild]) ifTrue: [
			^ out nextPutAll: programEntity asString
		] 
	].

	programEntity parent ifNil: [
		programEntity isNamespace ifTrue: [
			out nextPutAll: programEntity module name.
			^ self.
		].
	] ifNotNil: [
		self unmangledNameForProgramEntity: programEntity parent into: out.
		(programEntity name isMbndAnonymousSymbol and: [ programEntity parent isTemplateInstance ]) ifTrue: [  ^ self ].
			
		programEntity isTemplateInstance ifFalse: [ 
			out nextPutAll: '::'
		].
	].

	programEntity isTemplateInstance ifTrue: [ 
		programEntity module == programEntity parent module ifFalse: [ 
			out nextPut: $[.
			out nextPutAll: programEntity module name.
			out nextPut: $].
		].
		out nextPut: $(.
		programEntity instanceArguments doWithIndex: [ :arg :index |
			index > 1 ifTrue: [ out nextPut: $, ].
			out print: arg evaluatedValue unwrapMbndValue
		].
		out nextPut: $).
		^ self
	].

	programEntity isMessageMethod ifTrue: [ out nextPut: $[ ].
	out nextPutAll: (programEntity name isMbndAnonymousSymbol
		ifTrue: [ self generatedNameForAnynomousEntity: programEntity ]
		ifFalse: [ programEntity name ]).
	programEntity isMessageMethod ifTrue: [ out nextPut: $] ].
		
	self addUnmangledProgramEntity: programEntity suffixInto: out
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> unmangledNameForShaderEntryPoint: programEntity [
	^ ByteString streamContents: [ :out |
		self unmangledNameForShaderEntryPoint: programEntity into: out
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> unmangledNameForShaderEntryPoint: programEntity into: out [
	programEntity isMbndType ifTrue: [ 
		(programEntity isCoreBasicType or: [programEntity isSystemProvidedTypeTemplateInstanceMainChild]) ifTrue: [
			^ out nextPutAll: programEntity asString
		] 
	].

	programEntity parent ifNil: [
		programEntity isNamespace ifTrue: [ ^ self ].
	] ifNotNil: [
		self unmangledNameForShaderEntryPoint: programEntity parent into: out.
		(programEntity name isMbndAnonymousSymbol and: [ programEntity parent isTemplateInstance ]) ifTrue: [  ^ self ].
			
		programEntity parent parent ifNotNil: [ 
			programEntity isTemplateInstance ifFalse: [ 
				out nextPutAll: '::'
			].
		].
	].

	programEntity isTemplateInstance ifTrue: [ 
		programEntity module == programEntity parent module ifFalse: [ 
			out nextPut: $[.
			out nextPutAll: programEntity module name.
			out nextPut: $].
		].
		out nextPut: $(.
		programEntity instanceArguments doWithIndex: [ :arg :index |
			index > 1 ifTrue: [ out nextPut: $, ].
			out print: arg evaluatedValue unwrapMbndValue
		].
		out nextPut: $).
		^ self
	].

	programEntity isMessageMethod ifTrue: [ out nextPut: $[ ].
	out nextPutAll: (programEntity name isMbndAnonymousSymbol
		ifTrue: [ self generatedNameForAnynomousEntity: programEntity ]
		ifFalse: [ programEntity name ]).
	programEntity isMessageMethod ifTrue: [ out nextPut: $] ].
		
	self addUnmangledProgramEntity: programEntity suffixInto: out
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> validConstructionRecordFor: value priority: priority [
	^ constructionRecordDictionary at: value ifAbsentPut: [
		| record |
		record := MbndSlovimConstructionRecord new
			priority: priority;
			yourself.
		constructionRecords add: record.
		record
	]
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> validSourcePosition [
	^ MbndSourcePosition empty
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> variantUnexpectedComponentRaiseFunction [
	^ variantUnexpectedComponentRaiseFunction ifNil: [
		self compilationTarget variantUnexpectedComponentRaiseFunction ifNotNil: [ :function |
			variantUnexpectedComponentRaiseFunction := (self translateProgramEntity: function) ssaValue
		] ifNil: [
			variantUnexpectedComponentRaiseFunction := SLVMFunction module: ssaModule
				name: #__sysmel_variantUnexpectedComponentRaise
				functionType: (SLVMFunctionType arguments: #() returnType: self slvmCompilationTarget void)

		]
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateBasicInitializeMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		| receiver field |
		receiver := ssaFunction arguments first.
		generatedMethod parent slotLayout slots do: [ :slot |
			slot fields size = 1 ifTrue: [ 
				field := slot fields first.
				field isVTablePointerField ifTrue: [ 
					builder store: (self translateLiteralValue: (field defaultValueAt: MbndSourcePosition empty) ofType: field valueType)
						in: (builder getReference: receiver element: (builder constInt: field slotIndex)).
				] ifFalse: [ 
					field valueType hasTrivialBasicInitialization ifFalse: [ 
						builder call: (self translateProgramEntity: field valueType basicInitializeMethod) ssaValue
							arguments: { (builder getReference: receiver element: (builder constInt: field slotIndex)) }.
					]
				].
			]
		].
	
		builder returnVoid
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateCopyAssignmentMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticCopyAssignmentCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateFinalizeMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticFinalizationCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateInitializeFromCopyMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticInitializationFromCopyCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateInitializeMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticInitializationCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateInitializeMovingFromMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticInitializationMovingFromCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]

	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateMoveAssignmentMethod: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		functionCodeGenerator generateAutomaticMoveAssignmentCode.
		ssaFunction returnType isVoidType ifTrue: [ 
			builder returnVoid.
		] ifFalse: [ 
			builder return: ssaFunction arguments first.
		]
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateTypeWithFields: type [
	| ssaType ssaValue ssaTypeValueType |
	ssaType := self translateType: type.
	ssaTypeValueType := self translateType: type type.
	type mustBeAvailableInTheGPU ifTrue: [ gpuUsableProgramEntitites add: type ].

	type isGCClassType ifTrue: [
		type isMetaType ifFalse: [ 
			ssaModule addStructure: ssaType baseType.
			ssaModule addHighLevelEntity: type mapToStructureType: ssaType baseType.

			ssaModule addStructure: ssaTypeValueType baseType.
			ssaModule addHighLevelEntity: type type mapToStructureType: ssaTypeValueType baseType.
		].
	] ifFalse: [
		(ssaType isStructureType and: [ ssaType name isNotNil ]) ifTrue: [ 
			ssaModule addStructure: ssaType.
			ssaModule addHighLevelEntity: type mapToStructureType: ssaType.
		]
	].

	ssaValue := self translateTypeInfoDefinition: type.
	type isGCClassType ifFalse: [
		self translateProgramEntityChildren: type type.
	].  
	self translateProgramEntityChildren: type.
	^ ssaValue
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitArraySliceType: type [
	^ self visitSpecialStructureType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitArrayType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitAssociationType: type [
	^ self visitSpecialStructureType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitBlockClosureMethod: blockClosureMethod [
	| ssaFunctionType ssaClosureDefinition csymbol unmangledName kind normalFunctionType |
	ssaFunctionType := self translateType: blockClosureMethod type functionType.
	
	csymbol := self csymbolForProgramEntity: blockClosureMethod.
	unmangledName := self unmangledNameForProgramEntity: blockClosureMethod.

	kind := (blockClosureMethod closureKind = #gc ifTrue: [ #gc ] ifFalse: [#nativeStack]).
	normalFunctionType := blockClosureMethod boundType prependArguments: {blockClosureMethod type}.

	ssaClosureDefinition := SLVMClosureDefinition module: ssaModule functionType: ssaFunctionType.
	ssaClosureDefinition
		kind: kind;
		name: csymbol;
		unmangledName: unmangledName;
		propertyAt: #mbndFunctionType put: normalFunctionType;
		propertyAt: #mbndProgramEntity put: blockClosureMethod.
	self setProgramEntity: blockClosureMethod ssaValue: ssaClosureDefinition.

	self isEmittingDebugInformation ifTrue: [
		| debugInfo |
		debugInfo := self translateProgramEntityDebugInformation: blockClosureMethod.
		ssaClosureDefinition
			debugInformation: debugInfo;
			debugSourceLocation: (self convertDebugPosition: blockClosureMethod definitionPosition asActualSourcePosition)
	].

	self createFunctionCodeGenerator
			buildSSAClosure: ssaClosureDefinition definitionWith: blockClosureMethod.
	
	^ ssaClosureDefinition

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitClassType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitCompileTimeConstant: node [
	"For we will just ignore this here"
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitCompileTimeVariable: compileTimeVariable [
	"I am like a global variable, but I am always anonymous and private."
	| ssaValueType csymbol ssaCompileTimeVariable initialValue ssaReferenceType |
	ssaReferenceType := self translateType: compileTimeVariable type.
	ssaValueType := self sanitizeValueTypeForMemory: (self translateType: compileTimeVariable valueType).
	initialValue := compileTimeVariable value.

	(compileTimeVariable type isReferenceType not and: [ssaValueType == ssaReferenceType]) ifTrue: [
		| ssaConstantValue |
		"In the immutable, per value type case, treat this as a constant."
		ssaConstantValue := self translateLiteralValue: initialValue value ofType: initialValue type.
		self setProgramEntity: compileTimeVariable ssaValue: ssaConstantValue.
		^ ssaConstantValue
	].
	
	csymbol := (self generatedNameForAnynomousEntity: compileTimeVariable) asSymbol.
	ssaCompileTimeVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: (compileTimeVariable valueType hasGarbageCollectedAddressSpace ifTrue: [ SLVMType gcStorage ] ifFalse: [ SLVMType genericStorage ]).
	ssaCompileTimeVariable unmangledName: csymbol.
	self setProgramEntity: compileTimeVariable ssaValue: ssaCompileTimeVariable.
	ssaModule addHighLevelEntity: compileTimeVariable mapToGlobalValue: ssaCompileTimeVariable.

	self isEmittingDebugInformation ifTrue: [ 
		ssaCompileTimeVariable
			debugSourceLocation: (self convertDebugPosition: compileTimeVariable definitionPosition asActualSourcePosition);
			debugInformation: (self translateProgramEntityDebugInformation: compileTimeVariable)
	].

	ssaCompileTimeVariable readOnly: (compileTimeVariable type withoutReferences isConstantType).
	
	ssaCompileTimeVariable makePrivate.

	self assert: initialValue isNotNil.

	ssaCompileTimeVariable initialValue: (self sanitizeValue: (self translateLiteralValue: initialValue value ofType: initialValue type) withExpectedType: ssaValueType).
	
		
	^ ssaCompileTimeVariable
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitCompilerObjectType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteFunctionMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction unmangledName addHighLevelMap |
	functionMethod isAbstractVirtualMethod ifTrue: [
		^ self pureVirtualFunctionConstantWithType: (self translateType: functionMethod type pointer)
	].
	
	ssaFunctionType := self translateType: functionMethod type.
	csymbol := self csymbolForProgramEntity: functionMethod.
	csymbol isString ifTrue: [ 
		(ssaModule includesGlobalNamed: csymbol) ifTrue: [
			"Some runtime methods may be defined before there actual usage."
			ssaFunction := ssaModule globalNamed: csymbol.
			self assert: (csymbol beginsWith: #__sysmel).
			self assert: (ssaFunction isEmpty).
		].
	].

	addHighLevelMap := true.
	functionMethod mustBeAvailableInTheGPU ifTrue: [ gpuUsableProgramEntitites add: functionMethod ].
	(self slvmCompilationTarget isGPU and: [functionMethod specialSemantics isNotNil ]) ifTrue: [
		csymbol := self newSymbolNameMangler mangleProgramEntityName: functionMethod suffixes: {#__impl}.
		addHighLevelMap := false.
	].

	unmangledName := self unmangledNameForProgramEntity: functionMethod.
	ssaFunction ifNil: [ 
		ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	].

	ssaFunction
		setNoReturn: functionMethod isNoReturn;
		doesHaveMultipleReturns: functionMethod doesHaveMultipleReturns.
	
	addHighLevelMap ifTrue: [ 
		ssaModule addHighLevelEntity: functionMethod mapToGlobalValue: ssaFunction
	].

	ssaFunction unmangledName: unmangledName.
	self setProgramEntity: functionMethod ssaValue: ssaFunction.

	self isEmittingDebugInformation ifTrue: [
		
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: functionMethod);
			debugSourceLocation: (self convertDebugPosition: functionMethod definitionPosition asActualSourcePosition)
	].
	
	functionMethod analyzedBody ifNil: [
		ssaFunction makeExternal
	] ifNotNil: [
		self flag: 'TODO: Support the correct linkage/visibility.'.
		ssaFunction makePublic.
		self setupGCStrategyFor: ssaFunction generatedFrom: functionMethod.
		
		self createFunctionCodeGenerator
			buildSSAFunction: ssaFunction definitionWithConcreteMethod: functionMethod
	].
	
	functionMethod specialSemantics ifNotNil: [ 
		self slvmCompilationTarget isGPU ifTrue: [ 
			self createSpirVShaderControllerFor: functionMethod generatedAs: ssaFunction
		] ifFalse: [ 
			self createCPUShaderControllerFor: functionMethod generatedAs: ssaFunction
		]
	].


	^ ssaFunction
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteMessageMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction unmangledName |
	functionMethod isAbstractVirtualMethod ifTrue: [
		^ self pureVirtualFunctionConstantWithType: (self translateType: functionMethod type pointer)
	].

	ssaFunctionType := self translateType: functionMethod type.

	csymbol := self csymbolForProgramEntity: functionMethod.
	unmangledName := self unmangledNameForProgramEntity: functionMethod.
	csymbol isString ifTrue: [ 
		self assert: (ssaModule includesGlobalNamed: csymbol) not.
	].

	functionMethod mustBeAvailableInTheGPU ifTrue: [ gpuUsableProgramEntitites add: functionMethod ].

	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	ssaFunction
		setNoReturn: functionMethod isNoReturn;
		doesHaveMultipleReturns: functionMethod doesHaveMultipleReturns.
	ssaFunction unmangledName: unmangledName.

	self setProgramEntity: functionMethod ssaValue: ssaFunction.
	ssaModule addHighLevelEntity: functionMethod mapToGlobalValue: ssaFunction.
	
	self isEmittingDebugInformation ifTrue: [ 
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: functionMethod);
			debugSourceLocation: (self convertDebugPosition: functionMethod definitionPosition asActualSourcePosition)
	].

	functionMethod analyzedBody ifNil: [
		ssaFunction makeExternal
	] ifNotNil: [
		self flag: 'TODO: Support the correct linkage/visibility.'.
		ssaFunction makePublic.
		self setupGCStrategyFor: ssaFunction generatedFrom: functionMethod.
		
		self createFunctionCodeGenerator
			buildSSAFunction: ssaFunction definitionWithConcreteMethod: functionMethod
	].
	
	^ ssaFunction
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConstructorGroup: functionGroup [
	^ nil
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitCoreBasicType: coreBasicType [
	^ self translateTypeInfoDefinition: coreBasicType.
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitDynamicMethodWrapper: generatedMethod [
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder :functionCodeGenerator |
		| dynamicObjectType wrappedMethod wrappedMethodBoundType unwrappedReceiver unwrappedArguments unwrappedAllArguments callResultType calledFunction result convertedResult |
		dynamicObjectType := self compilationTarget dynamicObjectType.

		wrappedMethod := generatedMethod wrappedMethod.
		wrappedMethodBoundType := wrappedMethod boundType.
		
		unwrappedReceiver := wrappedMethod receiverType isVoidType ifTrue: [
			nil
		] ifFalse: [ 
			functionCodeGenerator unwrapDynamicObject: ssaFunction arguments first withType: dynamicObjectType intoValueOfType: wrappedMethod receiverType
		].
				
		unwrappedArguments := ssaFunction arguments allButFirst collectWithIndex: [ :argValue :argIndex |
			functionCodeGenerator unwrapDynamicObject: argValue withType: dynamicObjectType intoValueOfType: (wrappedMethodBoundType argumentTypes at: argIndex)
		].
	
		unwrappedAllArguments := unwrappedArguments.
		unwrappedReceiver ifNotNil: [
			unwrappedAllArguments := {unwrappedReceiver} , unwrappedArguments.
		].
	
		"Generate the call."
		calledFunction := (self translateProgramEntity: wrappedMethod) ssaValue.
		result := functionCodeGenerator generateCall: calledFunction arguments: unwrappedAllArguments calledFunctionType: wrappedMethod type.

		"Compute the actual result type."
		callResultType := wrappedMethodBoundType returnType.
		
		"Wrap the result."
		convertedResult := functionCodeGenerator wrapValue: result withType: callResultType intoDynamicObjectWithType: dynamicObjectType.
			
		"Finalize the temporary result."
		wrappedMethodBoundType returnType hasTrivialFinalization ifFalse: [
			self flag: 'FIXME: Make this finalization implicit by using clean-up actions.'.
			functionCodeGenerator generateVariable: result finalizationForValueType: wrappedMethodBoundType returnType
		].

		builder return: convertedResult
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitEnumType: type [
	^ self visitUserDefinedType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFieldVariable: field [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFunctionArgumentVariable: variable [
	"For now we will just ignore this here"
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFunctionCapturedVariable: variable [
	"For now we will just ignore this here"
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFunctionGroup: functionGroup [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFunctionLocalVariable: variable [
	"For now we will just ignore this here"
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitGCClassType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitGlobalVariable: globalVariable [
	| ssaValueType csymbol ssaGlobalVariable initialValue unmangledName storage isReadOnly hasInitialValue |
	ssaValueType := self sanitizeValueTypeForMemory: (self translateType: globalVariable valueType).
	
	globalVariable isStatic ifTrue: [ 
		csymbol := (self generatedNameForAnynomousEntity: globalVariable) asSymbol.
		unmangledName := globalVariable name asPrettySymbolName.
	] ifFalse: [ 
		csymbol := self csymbolForProgramEntity: globalVariable.
		unmangledName := self unmangledNameForProgramEntity: globalVariable.
	].

	storage := SLVMType genericStorage.
	globalVariable valueType hasGarbageCollectedAddressSpace ifTrue: [ 
		storage := SLVMType gcStorage
	].

	isReadOnly := globalVariable type isReferenceType not or: [globalVariable type withoutReferences isConstantType]. 
	hasInitialValue := globalVariable hasExternalVisibility not.

	self compilationTarget isGPU ifTrue: [
		(isReadOnly and: [ hasInitialValue ]) ifTrue: [
			initialValue := globalVariable currentRawValue.
			ssaGlobalVariable := MbndSlovimFoldingLiteralGlobal new
				value: (self translateLiteralValue: initialValue value ofType: initialValue type).
			self setProgramEntity: globalVariable ssaValue: ssaGlobalVariable.
			^ ssaGlobalVariable
		].
	].

	ssaGlobalVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: storage.
	ssaGlobalVariable unmangledName: unmangledName.
	ssaGlobalVariable minimalAlignment: globalVariable minimalAlignment.
	globalVariable isThreadLocal ifTrue: [
		self compilationTarget supportsDirectThreadLocalStorage ifTrue: [
			ssaGlobalVariable withGeneralDynamicTLSModel
		].
	].

	self setProgramEntity: globalVariable ssaValue: ssaGlobalVariable.
	ssaModule addHighLevelEntity: globalVariable mapToGlobalValue: ssaGlobalVariable.


	self isEmittingDebugInformation ifTrue: [ 
		ssaGlobalVariable
			debugSourceLocation: (self convertDebugPosition: globalVariable definitionPosition asActualSourcePosition);
			debugInformation: (self translateProgramEntityDebugInformation: globalVariable)
	].

	ssaGlobalVariable readOnly: isReadOnly.
	
	globalVariable hasExternalVisibility ifTrue: [
		ssaGlobalVariable makeExternal.
	] ifFalse: [ 
		initialValue := globalVariable currentRawValue.
		self assert: initialValue isNotNil.
		ssaGlobalVariable initialValue: (self sanitizeValue: (self translateLiteralValue: initialValue value ofType: initialValue type) withExpectedType: ssaValueType).
		
		  
		globalVariable isStatic ifTrue: [ 
			ssaGlobalVariable makePrivate
		].
	
		self
			generateInitializationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable;
			generateFinalizationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable
	].
		
	^ ssaGlobalVariable
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitInputChannelType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticBinaryOperationMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticBinaryOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticComparisonMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticUnaryOperationMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicPointerComparisonMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicPointerComparisonOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicThreeWayComparisonMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicThreeWayComparison new)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitMacroMessageMethod: macro [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitMessageGroup: functionGroup [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitModule: module [
	| moduleInfoClass moduleInfoPointerTypeClass moduleInfoSSAType moduleInfoInstance moduleInfoSSAValue |
	self slvmCompilationTarget objectModel moduleCodeGenerator: self.
	moduleInfoClass := self compilationTarget moduleInformationClass.
	
	moduleInfoPointerTypeClass := moduleInfoClass
		ifNil: [ self compilationTarget voidType pointer ]
		ifNotNil: [ moduleInfoClass isGCClassType
			ifTrue: [ moduleInfoClass ]
			ifFalse: [ moduleInfoClass pointer ] ].
	(moduleInfoClass isNil or: [ self compilationEnvironment hasRuntimeTypeInformation not or: [ self slvmCompilationTarget isGPU ] ])
		ifTrue: [ moduleInfoInstance := nil ]
		ifFalse: [ moduleInfoInstance := moduleInfoClass makeInstance ].
	
	moduleInfoSSAType := self translateType: moduleInfoPointerTypeClass.
	moduleInfoInstance ifNil: [
		moduleInfoSSAValue := moduleInfoSSAType defaultConstant.
		self setProgramEntity: module ssaValue: moduleInfoSSAValue
	] ifNotNil: [
		moduleInfoSSAValue := SLVMGlobalVariable
			module: ssaModule name: (self newSymbolNameMangler mangleProgramEntityInfo: module) valueType: moduleInfoSSAType baseType storage: (moduleInfoClass hasGarbageCollectedAddressSpace
		ifTrue: [SLVMType gcStorage]
		ifFalse: [SLVMType genericStorage]).
		self setProgramEntity: module ssaValue: moduleInfoSSAValue.
		ssaModule addHighLevelEntity: module mapToGlobalValue: moduleInfoSSAValue.
	].

	module moduleLevelInlineAssembly do: [ :inlineAssembly | self translateModuleLevelInlineAssembly: inlineAssembly ].

	"Translate the global namespace."
	self translateProgramEntity: module globalNamespace.

	"Translate the extension program entities."
	module allExtensionsDo: [ :extension |
		self translateProgramEntity: extension
	].

	"Set the module information fields."
	moduleInfoInstance ifNotNil: [
		self fillModuleInfoInstance: moduleInfoInstance	
	].


	self generateEmbeddedShaderModule ifNotNil: [ :embeddedShaderModule |
		"TODO: Store the embedded shader module in the module object."
	].

	"Set the module info global data."
	moduleInfoInstance ifNotNil: [
		self assert: moduleInfoSSAValue isGlobalVariable.
		moduleInfoSSAValue initialValue: (self literalValueGenerator translateObject: moduleInfoClass content: moduleInfoInstance).
		
		self createModuleInfoStartupConstructors: moduleInfoSSAValue
	].

	self generateGlobalConstructionSetupMethods.
	^ moduleInfoSSAValue
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitNamespace: namespace [
	| ssaValue |
	ssaValue := self translateProgramEntityInformationData: namespace.

	self translateProgramEntityChildren: namespace.
	^ ssaValue
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitNamespaceType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitOutputChannelType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPointerType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPredicatedTypeConcept: type [
	^ self visitUserDefinedType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveBooleanType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveCharacterCodeType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveFloatType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveIntegerType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveMatrixType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitPrimitiveVectorType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitReferenceType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitReturnType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitSimpleMetaType: type [
	^ self translateProgramEntityInformationData: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitSpecialStructureType: specialStructureType [
	^ self visitStructureType: specialStructureType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitStructureType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitTargetNamedIntrinsicMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedTargetSpecificIntrinsic new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitTemplate: template [
	self translateProgramEntityChildren: template.
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitTemplateInstance: templateInstance [
	self translateProgramEntityChildren: templateInstance.
	^ nil
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitTemporaryReferenceType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitTupleType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitUndefinedType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitUnionType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitUserDefinedType: type [
	| ssaValue |
	ssaValue := self translateTypeInfoDefinition: type.
	self translateProgramEntityChildren: type.
	^ ssaValue
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitVTablePointerFieldVariable: vtableField [
	| ssaValueType csymbol ssaVTableDefinition vtableEntryType additionalFields methodFields unmangledName |
	
	self assert: vtableField parent isNotNil.
	vtableEntryType := self slvmCompilationTarget voidPointerType.

	ssaValueType := SLVMArrayType baseType: vtableEntryType elements: 2 + vtableField vtableSlots size.
	unmangledName := self unmangledNameForProgramEntity: vtableField.
	csymbol := self mangleProgramEntityName: vtableField.
	
	ssaVTableDefinition := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	ssaVTableDefinition unmangledName: unmangledName.
	self setProgramEntity: vtableField ssaValue: ssaVTableDefinition.
	ssaModule addHighLevelEntity: vtableField mapToGlobalValue: ssaVTableDefinition.

	additionalFields := {
		"Offset" SLVMConstant type: vtableEntryType value: 0.
		"Type info" . SLVMConstant pointer: (self translateProgramEntity: vtableField parent) ssaValue castTo: vtableEntryType.
	}.
	
	methodFields := vtableField vtableSlots collect: [ :vtableMethod |
		SLVMConstant pointer: (self translateProgramEntity: vtableMethod) ssaValue
			castTo: vtableEntryType
	].
	
	ssaVTableDefinition
		readOnly: true;
		initialValue: (SLVMConstant array: ssaValueType slots: additionalFields , methodFields).

	vtableField parent hasPrivateVisibility ifTrue: [ 
		ssaVTableDefinition makePrivate
	].

	^ ssaVTableDefinition
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitVariantUnionType: type [
	^ self visitCoreBasicType: type
]

{ #category : #'typeinfo translation' }
MbndSlovimCodeModuleGenerator >> visitVoidType: type [
	^ self visitCoreBasicType: type
]
