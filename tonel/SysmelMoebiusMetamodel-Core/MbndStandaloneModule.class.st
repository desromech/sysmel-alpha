Class {
	#name : #MbndStandaloneModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationTarget',
		'useLibC',
		'hasRuntimeTypeInformation',
		'hasStandardLibrary',
		'hasGarbageCollectionSupport',
		'hasGarbageCollectionStackMap',
		'hasLibC',
		'optimizationLevel',
		'hasGPUSupport',
		'linkerArguments',
		'hasExceptions'
	],
	#classVars : [
		'MessagePackTypeMapTable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> compilationTarget: aCompilationTarget [
	^ self basicNew
		initializeWithCompilationTarget: aCompilationTarget;
		yourself

]

{ #category : #accessing }
MbndStandaloneModule class >> disableSLVMOptimizations [
	^ true
]

{ #category : #'class initialization' }
MbndStandaloneModule class >> initialize [
	MessagePackTypeMapTable := Dictionary newFromPairs: {
	#CoreBasicType . MbndBasicType.
	#CoreBasicMetaType . MbndSimpleMetaType.
	#SystemProvidedTypeTemplateInstance . MbndSystemProvidedTypeTemplateInstance.
	#SystemProvidedTypeTemplateInstanceMainChild . MbndSystemProvidedTypeTemplateInstance.
	#SystemProvidedTypeTemplateInstanceMainChildType . MbndSystemProvidedTypeTemplateInstance.
	#TargetModule . MbndStandaloneModule .
	#ReferenceModule . MbndStandaloneModule .
	}.
	{
		MbndAbstractCompileTimeConstant . MbndAbstractMethod .
		MbndAbstractMacro . MbndBasicType . MbndAbstractValue . 
		MbndAbstractModule . MbndAbstractNamespace .
		MbndAbstractTemplate . MbndAbstractTemplateInstance.
		MbndAbstractVariable . MbndTemplateDefinitionFragment .
		MbndAbstractScope . MbndAstNode . MbndAggregateSlotLayout . MbndAggregateSlotDescription
	} do: [:eachBase | eachBase withAllSubclassesDo: [ :each |
		each messagePackTypeName ifNotNil: [ :typeName |
			self assert: (MessagePackTypeMapTable includesKey: typeName) not.
			MessagePackTypeMapTable at: typeName put: each.
		]
	]].
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> llvm_x86 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> llvm_x86_64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86_64
]

{ #category : #serialization }
MbndStandaloneModule class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	(objectType == #TargetModule) ifTrue: [
		| fields objectInstance |
		objectInstance := graphDecoder targetModule.
		graphDecoder registerObjectInstance: objectInstance.
		fields := Dictionary newFromPairs: graphDecoder decodeNext.
		objectInstance materializeWithGraphDecoder: graphDecoder withFields: fields.
		^ objectInstance
	].

	(objectType == #ReferenceModule) ifTrue: [	
		self halt
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

{ #category : #serialization }
MbndStandaloneModule class >> messagePackTypeName [
	^ #StandaloneModule
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule class >> spirv_vulkan [
	^ self compilationTarget: MbndSlovimCompilationTarget spirv_vulkan
]

{ #category : #adding }
MbndStandaloneModule >> addLinkerArguments: arguments [
	<compileTime>
	self linkerArguments addAll: arguments
]

{ #category : #accessing }
MbndStandaloneModule >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndStandaloneModule >> disableSLVMOptimizations [
	^ self class disableSLVMOptimizations
]

{ #category : #serialization }
MbndStandaloneModule >> encodeFieldsForMessagePackWith: graphEncoder [
	| resultHead resultTail |
	resultHead := {
		"Hack: Ensure types are defined first to prevent a nasty circular border condition on deserialization."
		#definedTypes . Array streamContents: [ :out |
			self globalNamespace allChildrenDo: [ :child |
				child isMbndType ifTrue: [
					out nextPut: (child encodeGraphForMessagePackWith: graphEncoder)
				]
			]
		].
	}.
	
	resultTail := 
	{
		#globalNamespace . self globalNamespace encodeGraphForMessagePackWith: graphEncoder.
		#extensionMacros . self extensionMacros encodeGraphForMessagePackWith: graphEncoder.
		#extensionOverloadedMethods . self extensionOverloadedMethods encodeGraphForMessagePackWith: graphEncoder.
	}.
	
	^ resultHead , { 
		#definedTypesLazyFields . graphEncoder typeLazyFields.
	} , resultTail
]

{ #category : #serialization }
MbndStandaloneModule >> encodeGraphForMessagePackWith: graphEncoder [
	self == graphEncoder targetModule ifTrue: [ 
		^ graphEncoder encodeObject: self type: #TargetModule fields: [self encodeFieldsForMessagePackWith: graphEncoder]
	].

	^ super encodeGraphForMessagePackWith: graphEncoder
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> encodeModulePublicInterfaceWithSSAModule: ssaModule [
	| graphEncoder result exportedSSAModule |
	graphEncoder := MbndSerializationGraphEncoder new
		setExportMode;
		typeMapTable: MessagePackTypeMapTable;
		targetModule: self;
		yourself.
		exportedSSAModule := ssaModule asPublicInterfaceDeclarationModule.
	result := {
		#module . self encodeGraphForMessagePackWith: graphEncoder.
		#exportedSSAModule . exportedSSAModule asFullSExpression .
	}.
	
	^ SLVMMessagePackGraphEncoder encodeObject: result
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> exportModulePublicInterfaceTo: outputFileName withSSAModule: ssaModule [
	| publicModuleEncodedMessage |
	publicModuleEncodedMessage := self encodeModulePublicInterfaceWithSSAModule: ssaModule.
	outputFileName asFileReference binaryWriteStreamDo: [ :out |
		out truncate; nextPutAll: publicModuleEncodedMessage
	]
]

{ #category : #parameters }
MbndStandaloneModule >> freestanding [
	<compileTime>
	^ self
		noLibC;
		noRTTI.
]

{ #category : #parameters }
MbndStandaloneModule >> hasExceptions [
	^ hasExceptions ifNil: [ hasExceptions := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasExceptions: aBoolean [
	<compileTime>
	hasExceptions := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasGPUSupport [
	<compileTime>
	^ hasGPUSupport ifNil: [ hasGPUSupport := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionStackMap [
	<compileTime>
	^ hasGarbageCollectionStackMap ifNil: [ hasGarbageCollectionStackMap := false ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionStackMap: aBoolean [
	<compileTime>
	hasGarbageCollectionStackMap := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionSupport [
	<compileTime>
	^ hasGarbageCollectionSupport ifNil: [ hasGarbageCollectionSupport := self hasRuntimeTypeInformation ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionSupport: aBoolean [
	<compileTime>
	hasGarbageCollectionSupport := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasLibC [
	<compileTime>
	^ hasLibC ifNil: [ hasLibC := self compilationTarget isGPU not ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasLibC: aBoolean [
	<compileTime>
	hasLibC := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasPreciseGarbageCollector [
	^ false
]

{ #category : #parameters }
MbndStandaloneModule >> hasRuntimeTypeInformation [
	<compileTime>
	^ hasRuntimeTypeInformation ifNil: [ hasRuntimeTypeInformation := self compilationTarget isGPU not ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasRuntimeTypeInformation: aBoolean [
	<compileTime>
	hasRuntimeTypeInformation := aBoolean
]

{ #category : #parameters }
MbndStandaloneModule >> hasStandardLibrary [
	<compileTime>
	^ hasStandardLibrary ifNil: [ hasStandardLibrary := true ]
]

{ #category : #parameters }
MbndStandaloneModule >> hasStandardLibrary: aBoolean [
	<compileTime>
	hasStandardLibrary := aBoolean
]

{ #category : #serialization }
MbndStandaloneModule >> importModuleFrom: aModuleExportFileDefinition [
	| moduleExportFileContents decodedExportedModuleAttributes |
	moduleExportFileContents := aModuleExportFileDefinition asFileReference binaryReadStreamDo: [ :in | in contents ].
	decodedExportedModuleAttributes := Dictionary newFromPairs: (MbndMessagePackGraphDecoder new
		typeTable: MessagePackTypeMapTable;
		compilationTarget: compilationTarget;
		targetModule: self;
		decode: moduleExportFileContents).
	self assert: (decodedExportedModuleAttributes at: #module) == self.

	self globalNamespace
		postMaterializeSetupParent: nil withModule: self.
	
	self extensionMacros do: [ :each |
		| parentEntity macro |
		parentEntity := each first.
		macro := each third.
		macro parent ifNil: [ macro postMaterializeSetupParent: parentEntity withModule: self ]
	].

	self
		applyExtensionMacros;
		applyExtensionOverloadedMethods.
	
	"TODO: Store the SSA module for future code generation."
]

{ #category : #accessing }
MbndStandaloneModule >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	compilationTarget
		coreDefinitionsModule: self;
		initialize.
	self initialize
]

{ #category : #accessing }
MbndStandaloneModule >> linkerArguments [
	^ linkerArguments ifNil: [ linkerArguments := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadRuntimeCoreLibrary [
	^ self evaluateFileNamedOnce: MbndCoreAssets location  / 'lib' / 'kernel' / 'kernel.sysmel'. 
]

{ #category : #serialization }
MbndStandaloneModule >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	(encodedFields at: #definedTypesLazyFields) do: [ :each |
		each first materializeWithGraphDecoder: graphDecoder withLazyFields: (Dictionary newFromPairs: each second)
	].

	globalNamespace := encodedFields at: #globalNamespace.
	extensionMacros := encodedFields at: #extensionMacros.
	extensionOverloadedMethods := encodedFields at: #extensionOverloadedMethods.
]

{ #category : #parameters }
MbndStandaloneModule >> noExceptions [
	<compileTime>
	self hasExceptions: false
]

{ #category : #parameters }
MbndStandaloneModule >> noGC [
	<compileTime>
	self hasGarbageCollectionSupport: false
]

{ #category : #parameters }
MbndStandaloneModule >> noLibC [
	<compileTime>
	self
		hasLibC: false;
		useLibC: false
]

{ #category : #parameters }
MbndStandaloneModule >> noRTTI [
	<compileTime>
	self hasRuntimeTypeInformation: false
]

{ #category : #parameters }
MbndStandaloneModule >> noStandardLibrary [
	<compileTime>
	self hasStandardLibrary: false
]

{ #category : #parameters }
MbndStandaloneModule >> optimizationLevel [
	^ optimizationLevel ifNil: [ optimizationLevel := 0 ]
]

{ #category : #parameters }
MbndStandaloneModule >> optimizationLevel: anInteger [
	^ optimizationLevel := anInteger
]

{ #category : #parameters }
MbndStandaloneModule >> useLibC [
	<compileTime>
	^ useLibC ifNil: [ useLibC := self hasLibC ]
]

{ #category : #parameters }
MbndStandaloneModule >> useLibC: aBoolean [
	<compileTime>
	useLibC := aBoolean
]

{ #category : #initialization }
MbndStandaloneModule >> withDebugInformation [
	compilationTarget withDebugInformation
]

{ #category : #initialization }
MbndStandaloneModule >> withPositionIndependentCode [
	compilationTarget withPositionIndependentCode
]

{ #category : #writing }
MbndStandaloneModule >> writeAssemblyToFileNamed: outputFileName [
	^ self writeMode: #assembly toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeExecutableToFileNamed: outputFileName [
	^ self writeMode: #executable toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeLLVMAssemblyToFileNamed: outputFileName [
	^ self writeMode: #llvm_assembly toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeMode: writeMode toFileNamed: outputFileName [
	| lowLevelModule ssaModule outputFileReference outputExportModuleFileReference |
	self finishSemanticAnalysis.
	ssaModule := self generateTargetCodeModule.
	outputFileReference := outputFileName asFileReference.
	outputExportModuleFileReference := outputFileReference parent / (outputFileReference basenameWithoutExtension , '.smpmodule').
	
	ssaModule disableSLVMOptimizations: self disableSLVMOptimizations.
	ssaModule disableSLVMOptimizations ifFalse: [ 
		self optimizationLevel > 0 ifTrue: [ 
			ssaModule optimizeGlobalVariables
		].
	].

	MbndProfiler component: #lirCodeGeneration with: [ 
		lowLevelModule := ssaModule asLowLevelModuleWithOptimizationLevel: optimizationLevel.
		lowLevelModule linkerArguments: linkerArguments.
	].
	
	self exportModulePublicInterfaceTo: outputExportModuleFileReference withSSAModule: ssaModule.
	writeMode == #assembly ifTrue: [
		^ lowLevelModule writeAssemblyToFileNamed: outputFileName
	].

	writeMode == #llvm_assembly ifTrue: [
		^ lowLevelModule writeIRAssemblyToFileNamed: outputFileName
	].

	writeMode == #object ifTrue: [
		^ lowLevelModule writeObjectToFileNamed: outputFileName
	].

	writeMode == #executable ifTrue: [
		^ lowLevelModule writeExecutableToFileNamed: outputFileName
	].

	writeMode == #shared ifTrue: [
		^ lowLevelModule writeSharedToFileNamed: outputFileName
	].

	writeMode == #plugin ifTrue: [
		^ lowLevelModule writeSharedToFileNamed: outputFileName
	].

	self error: 'Writing mode ' , writeMode printString , ' not yet implemented'

]

{ #category : #writing }
MbndStandaloneModule >> writeObjectToFileNamed: outputFileName [
	^ self writeMode: #object toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeSharedToFileNamed: outputFileName [
	^ self writeMode: #shared toFileNamed: outputFileName
]
