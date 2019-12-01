Class {
	#name : #MbndSlovimCodeModuleGenerator,
	#superclass : #MbndAbstractCodeModuleGenerator,
	#instVars : [
		'sourceModule',
		'ssaModule',
		'translatedProgramEntities',
		'typeTranslator',
		'typeNameMangler',
		'programEntityTypeNameMangler',
		'anonSymbolCount',
		'debugLocationDictionary',
		'debugSourceFileDictionary',
		'identityHashRandomGenerator',
		'intrinsicConstantBuiltInFunctionCache',
		'convertedDescriptorSetBindings',
		'structuresWithAdditionalKinds',
		'convertedShaderIOFields'
	],
	#classVars : [
		'ShaderBuiltInLocationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimCodeModuleGenerator class >> initialize [
	ShaderBuiltInLocationMap := Dictionary newFromPairs: #(
		(vertex position) -1
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

{ #category : #visiting }
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

{ #category : #visiting }
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
	| csymbol shaderFunction builder argumentTypes stageInputType stageOutputType fetchedInput computedOutput receiverType receiver invocationArguments |
	csymbol := self csymbolForProgramEntity: functionMethod.
	(functionMethod hasFlag: #externC) ifTrue: [
		csymbol := functionMethod name.
	].

	receiverType := self translateType: functionMethod receiverType.
	argumentTypes := functionMethod boundType argumentTypes.
	self assert: argumentTypes size >= 1.
	stageInputType := argumentTypes first.
	stageOutputType := argumentTypes size >= 2 ifTrue: [argumentTypes second] ifFalse: [nil].

	shaderFunction := SLVMFunction module: ssaModule name: csymbol functionType: (SLVMFunctionType arguments: #() returnType: SLVMType voidType).
	shaderFunction propertyAt: functionMethod specialSemantics put: nil.
	
	builder := SLVMBuilder on: shaderFunction.
	builder newBasicBlockHere: #entry.
	
	"Allocate space for the IO data."
	receiver := receiverType isVoidType ifTrue: [nil] ifFalse: [builder alloca: receiverType baseType].
	
	fetchedInput := builder alloca: (self translateType: stageInputType messageType).
	computedOutput := stageOutputType ifNotNil: [builder alloca: (self translateType: stageOutputType messageType)].

	"Fetch the inputs."
	self fetchShader: functionMethod inputsOfType: stageInputType messageType into: fetchedInput with: builder.
	
	"Call the actual shader content."
	invocationArguments := #().
	receiver ifNotNil: [ invocationArguments := invocationArguments , { receiver } ].
	fetchedInput ifNotNil: [ invocationArguments := invocationArguments , { fetchedInput } ].
	computedOutput ifNotNil: [ invocationArguments := invocationArguments , { computedOutput } ].

	builder call: generatedSSAFunction arguments: invocationArguments.
	
	"Copy the computed results."
	computedOutput ifNotNil: [ 
		self storeShader: functionMethod outputsOfType: stageOutputType messageType from: computedOutput with: builder
	].
	
	builder returnVoid.
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> csymbolForProgramEntity: programEntity [
	programEntity name ifNil: [ ^ nil ].

	(programEntity hasFlag: #externC) ifTrue: [
		(self slvmCompilationTarget isSpirV and: [ programEntity specialSemantics isNotNil ]) ifFalse: [ 
			^ programEntity name
		].
	].

	^ self mangleProgramEntityName: programEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> escapeCharacterForMangling: c into: out [
	c = $_ ifTrue: [ 
		^ out nextPutAll: '__'
	].
	c = $: ifTrue: [ 
		^ out nextPutAll: '_c'
	].

	('<>+-*/%"''()#?!|&^~=' includes: c) ifTrue: [ ^ out nextPutAll: '_x' ; nextPutAll: c asInteger hex ].
	^ out nextPut: c

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> escapeNameForMangling: name [
	name ifNil: [ ^ '_anon' ].
	^ ByteString streamContents: [ :out |
		name do: [ :c |
			self escapeCharacterForMangling: c into: out
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

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule [
	sourceModule := aModule.
	ssaModule := SLVMModule new compilationTarget: self slvmCompilationTarget.
	self addPrimitiveTypeTranslations.
	self translateProgramEntity: sourceModule.
	
	^ ssaModule
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> generateGlobalField: field forDescriptorSet: set binding: binding [
	| globalName valueType globalStorage structureKind ssaValueType ssaGlobal |
	globalName := ByteString streamContents: [:out |
		out nextPutAll: (self csymbolForProgramEntity: field);
			nextPutAll: '_';
			nextPutAll: 'set'; print: set;
			nextPutAll: 'binding'; print: binding
	].

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
		self halt
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
	globalName := ByteString streamContents: [:out |
		out nextPutAll: (self csymbolForProgramEntity: field);
			nextPutAll: '_';
			nextPutAll: shaderStage;
			nextPutAll: '_'; nextPutAll: storage
	].

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
MbndSlovimCodeModuleGenerator >> generateIdentityHash [
	^ (identityHashRandomGenerator nextInt: (1<<32) + 1) - 1 
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> generatedNameForAnynomousEntity: programEntity [
	| result |
	programEntity isVTablePointerField ifTrue: [ ^ '__vtable' , programEntity slotIndex asString ].
	programEntity isCompileTimeVariable ifTrue: [
		result := '__compileTimeVariable' , anonSymbolCount asString.
		anonSymbolCount := anonSymbolCount + 1.
		^ result.
	].
	programEntity isTemplateInstance ifTrue: [
		self flag: 'TODO: Implement this properly'.
	].

	result := '<anon' , anonSymbolCount asString , '>'.
	anonSymbolCount := anonSymbolCount + 1.
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
MbndSlovimCodeModuleGenerator >> getShaderIOField: field storage: storage forStage: specialSemantics [
	^ convertedShaderIOFields at: {field . storage . specialSemantics} ifAbsentPut: [ 
		self generateGlobalField: field forShader: specialSemantics storage: storage
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> gpuTypeMapping [
	self slvmCompilationTarget isSpirV ifFalse: [ ^ #() ].
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
	| escapedNamed mangledType |
	programEntity ifNil: [ ^ #_S ].
	(programEntity name isNil and: [ programEntity isMbndType and: [programEntity isMetaType] ]) ifTrue: [
		^ ((self mangleProgramEntityName: programEntity instanceType) , '__meta') asSymbol
	].
	(programEntity parent isNil and: [ programEntity isNamespace ]) ifTrue: [ ^ #_S ].
	escapedNamed := self escapeNameForMangling: programEntity name.
	mangledType := self mangleProgramEntityType: programEntity.
	^ ((self mangleProgramEntityName: programEntity parent) , escapedNamed size asString , escapedNamed , mangledType) asSymbol
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityType: programEntity [
	^ self programEntityTypeNameMangler visitNode: programEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> programEntityTypeNameMangler [
	^ programEntityTypeNameMangler ifNil: [ programEntityTypeNameMangler := MbndSlovimProgramEntityTypeNameMangler new codeModuleGenerator: self ]
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
MbndSlovimCodeModuleGenerator >> translateCompilerGeneratedMethod: generatedMethod with: codeGenerationBlock [
	| ssaFunctionType csymbol ssaFunction unmangledName builder allocaBuilder bodyBlock |
	ssaFunctionType := self translateType: generatedMethod type.
	
	csymbol := self csymbolForProgramEntity: generatedMethod.
	unmangledName := self unmangledNameForProgramEntity: generatedMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	ssaFunction unmangledName: unmangledName.
	
	self setProgramEntity: generatedMethod ssaValue: ssaFunction.

	self flag: 'TODO: Support the correct linkage/visibility.'.
	ssaFunction makePublic.
	self setupGCStrategyFor: ssaFunction generatedFrom: generatedMethod.
	
	"Create the builder, and the main blocks."
	builder := SLVMBuilder on: ssaFunction.
	allocaBuilder := SLVMBuilder on: ssaFunction.
	allocaBuilder newBasicBlockHere: #entry.
	builder allocaBuilder: allocaBuilder.
	bodyBlock := builder newBasicBlockHere: #body.

	"Generate the method content."	
	codeGenerationBlock value: ssaFunction value: builder.
	
	"Jump from the alloca builder into the body method."
	allocaBuilder jump: bodyBlock.

	^ ssaFunction
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

	(sourceModule hasRuntimeTypeInformation not or: [self slvmCompilationTarget isSpirV ]) ifTrue: [
		self assert: type isGCClassType not.
		ssaTypeInfo := SLVMConstant nullPointer: ssaTypeInfoType.
		self setProgramEntity: type ssaValue: ssaTypeInfo.
		^ ssaTypeInfo
	].

	self assert: ssaTypeInfoType isPointerType.
	ssaTypeInfo := SLVMGlobalVariable module: ssaModule name: ((self mangleProgramEntityName: type ) , 'Ti') asSymbol valueType: ssaTypeInfoType baseType storage: SLVMType genericStorage.
	self setProgramEntity: type ssaValue: ssaTypeInfo.
	
	ssaTypeInfo initialValue: (MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self;
		translateTypeInfoContent: type).

	^ ssaTypeInfo
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateTypes: aType [
	^ self typeTranslator translateTypes: aType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> typeNameMangler [
	^ typeNameMangler ifNil: [ typeNameMangler := MbndSlovimTypeNameMangler new codeModuleGenerator: self ]
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
			(programEntity name isMbndAnonymousSymbol and: [ programEntity parent isTemplateInstance ]) ifTrue: [ ^ self ].

			out nextPutAll: '::'
		].
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
	^ self translateCompilerGeneratedMethod: generatedMethod with: [ :ssaFunction :builder |
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

	self isEmittingDebugInformation ifTrue: [ 
		ssaCompileTimeVariable debugSourceLocation: (self convertDebugPosition: compileTimeVariable definitionPosition asActualSourcePosition)
	].

	ssaCompileTimeVariable readOnly: (compileTimeVariable type withoutReferences isConstantType).
	
	ssaCompileTimeVariable makePrivate.

	self assert: initialValue isNotNil.

	ssaCompileTimeVariable initialValue: (self translateLiteralValue: initialValue value ofType: initialValue type).
		
	^ ssaCompileTimeVariable
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteFunctionMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction unmangledName |
	ssaFunctionType := self translateType: functionMethod type.
	
	csymbol := self csymbolForProgramEntity: functionMethod.
	(self slvmCompilationTarget isSpirV and: [functionMethod specialSemantics isNotNil ]) ifTrue: [ 
		csymbol := (csymbol , #_impl) asSymbol
	].

	unmangledName := self unmangledNameForProgramEntity: functionMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.

	ssaFunction unmangledName: unmangledName.
	self setProgramEntity: functionMethod ssaValue: ssaFunction.

	self isEmittingDebugInformation ifTrue: [ 
		ssaFunction debugSourceLocation: (self convertDebugPosition: functionMethod definitionPosition asActualSourcePosition)
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
	
	self isEmittingDebugInformation ifTrue: [ 
		ssaFunction debugSourceLocation: (self convertDebugPosition: functionMethod definitionPosition asActualSourcePosition)
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
	
	csymbol := self csymbolForProgramEntity: globalVariable.
	unmangledName := self unmangledNameForProgramEntity: globalVariable.
	ssaGlobalVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	ssaGlobalVariable unmangledName: unmangledName.
	self setProgramEntity: globalVariable ssaValue: ssaGlobalVariable.

	self isEmittingDebugInformation ifTrue: [ 
		ssaGlobalVariable debugSourceLocation: (self convertDebugPosition: globalVariable definitionPosition asActualSourcePosition)
	].

	ssaGlobalVariable readOnly: (globalVariable type withoutReferences isConstantType).
	
	globalVariable hasExternalVisibility ifTrue: [
		ssaGlobalVariable makeExternal.
	] ifFalse: [ 
		initialValue := globalVariable currentValue.
		self assert: initialValue isNotNil.
		ssaGlobalVariable initialValue: (self translateLiteralValue: initialValue value ofType: initialValue type).
		globalVariable isStatic ifTrue: [ 
			ssaGlobalVariable makePrivate
		].
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
	ssaVTableDefinition
		readOnly: true;
		initialValue: (SLVMConstant array: ssaValueType slots: additionalFields , methodFields).

	vtableField parent hasPrivateVisibility ifTrue: [ 
		ssaVTableDefinition makePrivate
	].

	^ ssaVTableDefinition
]
