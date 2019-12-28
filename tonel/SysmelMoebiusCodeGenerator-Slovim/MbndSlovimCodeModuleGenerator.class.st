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
		'symbolNameManglerPrototype'
	],
	#classVars : [
		'ShaderBuiltInLocationMap'
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
	
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> addPrimitiveTypeTranslations [
	| sourceTarget destTarget sourceType destType |
	sourceTarget := sourceModule compilationTarget.
	destTarget := self slvmCompilationTarget.
	
	(#(
		(voidType void)

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
MbndSlovimCodeModuleGenerator >> compilationTarget [
	^ sourceModule compilationTarget
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> convertDebugPosition: aPosition [
	^ debugLocationDictionary at: aPosition ifAbsentPut: [ SLVMDebugLocation new
			sourceFile: (self convertDebugSourceFile: aPosition collection);
			start: aPosition start;
			stop: aPosition stop;
			startLine: aPosition line;
			startColumn: aPosition column;
			endLine: aPosition endLine;
			endColumn: aPosition endColumn;
			collection: aPosition collection;
			yourself ]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> convertDebugSourceFile: aSourceCollection [
	| sourceRef |
	^ debugSourceFileDictionary at: aSourceCollection ifAbsentPut: [ 
		sourceRef := (aSourceCollection ifNil: ['generated'] ifNotNil: [aSourceCollection name]) asFileReference.
		SLVMDebugSourceFile new
			directory: sourceRef parent fullName;
			name: sourceRef basename
	]
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> createFunctionCodeGenerator [
	^ MbndSlovimFunctionCodeGenerator new
		codeModuleGenerator: self;
		yourself
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> createSpirVShaderControllerFor: functionMethod generatedAs: generatedSSAFunction [
	| csymbol shaderFunction builder argumentTypes receiverType receiver invocationArguments inputChannels outputChannels boundArguments fetchedInputs computedOutputs |
	csymbol := self csymbolForProgramEntity: functionMethod.
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

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule [
	^ self generateCodeModuleFor: aModule programEntities: { aModule }
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule programEntities: programEntitities [
	sourceModule := aModule.
	ssaModule := SLVMModule new compilationTarget: self slvmCompilationTarget.
	ssaModule sourceLanguageName: 'C++'. "HACK"
	
	self addPrimitiveTypeTranslations.
	programEntitities do: [ :each | self translateProgramEntity: each ].
	
	^ ssaModule
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

	ssaModule addGlobal: ssaGlobalVariable destructor: dtor priority: (globalVariable constructionPriority ifNil: [0])
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

	globalVariable initialValueKind = #copy ifTrue: [
		self assert: globalVariable initialValueFunclet isNotNil.
		ctor := self translateCompilerGeneratedMethodNamed: nil functionType: globalCtorFunctionType
			at: globalVariable definitionNode
			with: [ :ssaFunction :builder :functionCodeGenerator |
			| funcletValue |
			funcletValue := functionCodeGenerator generateFuncletValue: globalVariable initialValueFunclet withArguments: #().

			functionCodeGenerator generateVariable: ssaGlobalVariable withValueType: valueType initializationWithValue: funcletValue initialValueKind: globalVariable initialValueKind.
			
			builder returnVoid
		]
	].

	ctor ifNil: [ 
		self error: 'Unsupported global initialization kind'	
	].

	ssaModule addGlobal: ssaGlobalVariable constructor: ctor priority: (globalVariable constructionPriority ifNil: [0])
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
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> intrinsicConstantBuiltInFunction: intrinsicName withType: functionType [
	| ssaFunctionType |
	ssaFunctionType := self translateType: functionType.
	^ intrinsicConstantBuiltInFunctionCache at: { intrinsicName . ssaFunctionType } ifAbsentPut: [ 
		SLVMConstantBuiltInFunction pointerSize: self slvmCompilationTarget pointerSize
			name: intrinsicName
			functionType: ssaFunctionType
	]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> isEmittingDebugInformation [
	^ self slvmCompilationTarget emittingDebugInformation
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityName: programEntity [
	^ self newSymbolNameMangler mangleProgramEntityName: programEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityNestedName: programEntity [
	| escapedNamed validName result |
	programEntity ifNil: [ ^ #N ].
	(programEntity name isMbndAnonymousSymbol and: [ programEntity isMbndType and: [programEntity isMetaType] ]) ifTrue: [
		^ ((self mangleProgramEntityNestedName: programEntity instanceType) , '8__Type__') asSymbol
	].
	(programEntity parent isNil and: [ programEntity isNamespace ]) ifTrue: [ ^ #N ].
	
	validName := programEntity name.
	programEntity isTemplateInstance ifTrue: [ validName := '' ].
	(validName isMbndAnonymousSymbol and: [ programEntity parent isNotNil and: [ programEntity parent isTemplateInstance ] ]) ifTrue: [ validName := '' ].
	validName isMbndAnonymousSymbol ifTrue: [ validName := self generatedNameForAnynomousEntity: programEntity ].
	
	escapedNamed := self escapeNameForMangling: validName.

	result := self mangleProgramEntityNestedName: programEntity parent.
	escapedNamed ifNotEmpty: [ 
		result := result , escapedNamed size asString , escapedNamed.
	].
	
	^ result
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> newSymbolNameMangler [
	^ self symbolNameManglerPrototype copy
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

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> slvmCompilationTarget [
	^ sourceModule compilationTarget slvmCompilationTarget
]

{ #category : #initialization }
MbndSlovimCodeModuleGenerator >> ssaModule [
	^ ssaModule
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

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateCompilerGeneratedMethod: generatedMethod with: codeGenerationBlock [
	| ssaFunctionType csymbol ssaFunction unmangledName |
	ssaFunctionType := self translateType: generatedMethod type.
	
	csymbol := self csymbolForProgramEntity: generatedMethod.
	unmangledName := self unmangledNameForProgramEntity: generatedMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	ssaFunction unmangledName: unmangledName.
	
	self setProgramEntity: generatedMethod ssaValue: ssaFunction.

	self isEmittingDebugInformation ifTrue: [
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: generatedMethod);
			debugType: (self translateDebugType: generatedMethod type)
	].

	self flag: 'TODO: Support the correct linkage/visibility.'.
	ssaFunction makePublic.
	generatedMethod isFunclet ifTrue: [ ssaFunction makePrivate ].
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
			debugType: (self translateDebugType: functionType)
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
	^ MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self;
		translateDynamicObjectInstanceContent: dynamicObject
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateLiteralValue: literalValue ofType: literalType [
	^ MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self;
		translateLiteralValue: literalValue ofType: literalType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateModuleLevelInlineAssembly: inlineAssembly [
	ssaModule addArchitecture: inlineAssembly architecture language: inlineAssembly dialect inlineAssembly: inlineAssembly assembly
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntity: programEntity [
	^ translatedProgramEntities at: programEntity ifAbsent: [
		| ssaValue |
		ssaValue := programEntity accept: self.
		translatedProgramEntities at: programEntity ifAbsent: [
			self setProgramEntity: programEntity ssaValue: ssaValue
		].
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
	| ssaTypeInfo ssaTypeInfoType metaType |
	metaType := type type.
	ssaTypeInfoType := self translateType: metaType.

	(sourceModule hasRuntimeTypeInformation not or: [self slvmCompilationTarget isGPU ]) ifTrue: [
		self assert: type isGCClassType not.
		ssaTypeInfo := SLVMConstant nullPointer: ssaTypeInfoType.
		self setProgramEntity: type ssaValue: ssaTypeInfo.
		^ ssaTypeInfo
	].

	self assert: ssaTypeInfoType isPointerType.
	ssaTypeInfo := SLVMGlobalVariable module: ssaModule name: (self newSymbolNameMangler mangleTypeInfo: type) valueType: ssaTypeInfoType baseType storage: SLVMType genericStorage.
	self setProgramEntity: type ssaValue: ssaTypeInfo.
	ssaModule addHighLevelEntity: type mapToGlobalValue: ssaTypeInfo.
	
	ssaTypeInfo initialValue: (MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self;
		translateTypeInfoContent: type).

	^ ssaTypeInfo
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
	programEntity parent ifNotNil: [
		programEntity parent parent ifNotNil: [ "Remove __global"
			self unmangledNameForProgramEntity: programEntity parent into: out.
			(programEntity name isMbndAnonymousSymbol and: [ programEntity parent isTemplateInstance ]) ifTrue: [  ^ self ].
			
			programEntity isTemplateInstance ifFalse: [ 
				out nextPutAll: '::'
			].
		].
	].

	programEntity isTemplateInstance ifTrue: [ 
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
	
		builder return: receiver
	]

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateTypeWithFields: type [
	| ssaType ssaValue ssaTypeValueType |
	ssaType := self translateType: type.
	ssaTypeValueType := self translateType: type type.

	type isGCClassType ifTrue: [
		type isMetaType ifFalse: [ 
			ssaModule addStructure: ssaType baseType.
			ssaModule addStructure: ssaTypeValueType baseType.
		].
	] ifFalse: [
		(ssaType isStructureType and: [ ssaType name isNotNil ]) ifTrue: [ 
			ssaModule addStructure: ssaType
		]
	].

	ssaValue := self translateTypeInfoDefinition: type.
	self translateProgramEntityChildren: type.
	^ ssaValue
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
	ssaValueType := self translateType: compileTimeVariable valueType.
	initialValue := compileTimeVariable value.

	(compileTimeVariable type isReferenceType not and: [ssaValueType == ssaReferenceType]) ifTrue: [
		| ssaConstantValue |
		"In the immutable, per value type case, treat this as a constant."
		ssaConstantValue := self translateLiteralValue: initialValue value ofType: initialValue type.
		self setProgramEntity: compileTimeVariable ssaValue: ssaConstantValue.
		^ ssaConstantValue
	].
	
	csymbol := (self generatedNameForAnynomousEntity: compileTimeVariable) asSymbol.
	ssaCompileTimeVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
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

	ssaCompileTimeVariable initialValue: (self translateLiteralValue: initialValue value ofType: initialValue type).
		
	^ ssaCompileTimeVariable
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteFunctionMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction unmangledName addHighLevelMap |
	ssaFunctionType := self translateType: functionMethod type.
	
	csymbol := self csymbolForProgramEntity: functionMethod.
	addHighLevelMap := true.
	(self slvmCompilationTarget isGPU and: [functionMethod specialSemantics isNotNil ]) ifTrue: [ 
		csymbol := self newSymbolNameMangler mangleProgramEntityName: functionMethod suffixes: {#__impl}.
		addHighLevelMap := false.
	].

	unmangledName := self unmangledNameForProgramEntity: functionMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	
	addHighLevelMap ifTrue: [ 
		ssaModule addHighLevelEntity: functionMethod mapToGlobalValue: ssaFunction
	].

	ssaFunction unmangledName: unmangledName.
	self setProgramEntity: functionMethod ssaValue: ssaFunction.

	self isEmittingDebugInformation ifTrue: [
		
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: functionMethod);
			debugType: (self translateDebugType: functionMethod type);
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
	
	(self slvmCompilationTarget isSpirV and: [functionMethod specialSemantics isNotNil ]) ifTrue: [ 
		self createSpirVShaderControllerFor: functionMethod generatedAs: ssaFunction
	].

	^ ssaFunction
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteMessageMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction unmangledName |
	ssaFunctionType := self translateType: functionMethod type.
	
	csymbol := self csymbolForProgramEntity: functionMethod.
	unmangledName := self unmangledNameForProgramEntity: functionMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	ssaFunction unmangledName: unmangledName.
	self setProgramEntity: functionMethod ssaValue: ssaFunction.
	ssaModule addHighLevelEntity: functionMethod mapToGlobalValue: ssaFunction.
	
	self isEmittingDebugInformation ifTrue: [ 
		ssaFunction
			debugInformation: (self translateProgramEntityDebugInformation: functionMethod);
			debugType: (self translateDebugType: functionMethod type);
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
MbndSlovimCodeModuleGenerator >> visitEnumType: type [
	^ self visitUserDefinedType: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFieldVariable: field [
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
	| ssaValueType csymbol ssaGlobalVariable initialValue unmangledName |
	ssaValueType := self translateType: globalVariable valueType.
	
	globalVariable isStatic ifTrue: [ 
		csymbol := (self generatedNameForAnynomousEntity: globalVariable) asSymbol.
		unmangledName := globalVariable name asPrettySymbolName.
	] ifFalse: [ 
		csymbol := self csymbolForProgramEntity: globalVariable.
		unmangledName := self unmangledNameForProgramEntity: globalVariable.
	].
	ssaGlobalVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	ssaGlobalVariable unmangledName: unmangledName.
	ssaGlobalVariable minimalAlignment: globalVariable minimalAlignment.
	self setProgramEntity: globalVariable ssaValue: ssaGlobalVariable.
	ssaModule addHighLevelEntity: globalVariable mapToGlobalValue: ssaGlobalVariable.

	self isEmittingDebugInformation ifTrue: [ 
		ssaGlobalVariable
			debugSourceLocation: (self convertDebugPosition: globalVariable definitionPosition asActualSourcePosition);
			debugInformation: (self translateProgramEntityDebugInformation: globalVariable)
	].

	ssaGlobalVariable readOnly: (globalVariable type isReferenceType not or: [globalVariable type withoutReferences isConstantType]).
	
	globalVariable hasExternalVisibility ifTrue: [
		ssaGlobalVariable makeExternal.
	] ifFalse: [ 
		initialValue := globalVariable currentRawValue.
		self assert: initialValue isNotNil.
		ssaGlobalVariable initialValue: (self translateLiteralValue: initialValue value ofType: initialValue type).
		globalVariable isStatic ifTrue: [ 
			ssaGlobalVariable makePrivate
		].
	
		self
			generateInitializationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable;
			generateFinalizationOfGlobalVariable: globalVariable withSSAValue: ssaGlobalVariable
	].
		
	^ ssaGlobalVariable
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
MbndSlovimCodeModuleGenerator >> visitMacroMessageMethod: macro [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitMessageGroup: functionGroup [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitModule: module [
	self slvmCompilationTarget objectModel moduleCodeGenerator: self.
	module moduleLevelInlineAssembly do: [ :inlineAssembly | self translateModuleLevelInlineAssembly: inlineAssembly ].
	^ self translateProgramEntity: module globalNamespace
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitNamespace: namespace [
	self translateProgramEntityChildren: namespace.
	^ nil
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
	
	vtableEntryType := self slvmCompilationTarget voidPointerType.
	additionalFields := {
		"Offset" SLVMConstant type: vtableEntryType value: 0.
		"Type info" . SLVMConstant pointer: (self translateProgramEntity: vtableField parent) ssaValue castTo: vtableEntryType.
	}.
	
	methodFields := vtableField vtableSlots collect: [ :vtableMethod |
		SLVMConstant pointer: (self translateProgramEntity: vtableMethod) ssaValue
			castTo: vtableEntryType
	].
	
	ssaValueType := (SLVMArrayType baseType: vtableEntryType elements: additionalFields size + methodFields size ).
	unmangledName := self unmangledNameForProgramEntity: vtableField.
	csymbol := self mangleProgramEntityName: vtableField.
	
	ssaVTableDefinition := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	ssaVTableDefinition unmangledName: unmangledName.
	self setProgramEntity: vtableField ssaValue: ssaVTableDefinition.
	ssaModule addHighLevelEntity: vtableField mapToGlobalValue: ssaVTableDefinition.
	ssaVTableDefinition
		readOnly: true;
		initialValue: (SLVMConstant array: ssaValueType slots: additionalFields , methodFields).

	vtableField parent hasPrivateVisibility ifTrue: [ 
		ssaVTableDefinition makePrivate
	].

	^ ssaVTableDefinition
]
