Class {
	#name : #MbndStandaloneModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationEnvironment',
		'sourceLocations',
		'linkerArguments',
		'importedModules',
		'loadedPackageStates'
	],
	#classVars : [
		'MessagePackTypeMapTable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #accessing }
MbndStandaloneModule class >> disableSLVMOptimizations [
	^ true
]

{ #category : #'instance creation' }
MbndStandaloneModule class >> for: aCompilationEnvironment [
	^ self basicNew initializeWithCompilationEnvironment: aCompilationEnvironment; yourself
]

{ #category : #'class initialization' }
MbndStandaloneModule class >> initialize [
	MessagePackTypeMapTable := Dictionary newFromPairs: {
	#CoreBasicType . MbndBasicType.
	#CoreBasicMetaType . MbndSimpleMetaType.
	#CompilationTarget . MbndAbstractConcreteCompilationTarget.
	#CompilationEnvironment . MbndCompilationEnvironment.
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
		MbndAbstractScope . MbndAstNode . MbndAggregateSlotLayout .
		MbndAggregateSlotDescription . MbndGeneratedSymbol
	} do: [:eachBase | eachBase withAllSubclassesDo: [ :each |
		each messagePackTypeName ifNotNil: [ :typeName |
			self assert: (MessagePackTypeMapTable includesKey: typeName) not.
			MessagePackTypeMapTable at: typeName put: each.
		]
	]].
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
		| referencedModuleName referencedModule|
		referencedModuleName := graphDecoder decodeNext.
		referencedModule := graphDecoder compilationEnvironment importModuleNamed: referencedModuleName.
		graphDecoder registerObjectInstance: referencedModule.
		^ referencedModule
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

{ #category : #serialization }
MbndStandaloneModule class >> messagePackTypeName [
	^ #StandaloneModule
]

{ #category : #adding }
MbndStandaloneModule >> addLinkerArguments: arguments [
	<compileTime>
	self compilationEnvironment addLinkerArguments: arguments
]

{ #category : #accessing }
MbndStandaloneModule >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
MbndStandaloneModule >> compilationTarget [
	^ compilationEnvironment compilationTarget
]

{ #category : #serialization }
MbndStandaloneModule >> decodeImportedSSAModules: importedSSAModules [
	importedSSAModules keysAndValuesDo: [ :moduleName :moduleAttributesList |
		| moduleAttributes exportedSSAModule |
		moduleAttributes := Dictionary newFromPairs: moduleAttributesList.
		exportedSSAModule := SLVMModule new
			compilationTarget: self compilationTarget slvmCompilationTarget;
			decodeFromFullSExpression: (moduleAttributes at: #module).
		(moduleAttributes at: #programEntityMapToAggregateType) pairsDo: [ :programEntity :aggregateTypeName |
			exportedSSAModule addHighLevelEntity: programEntity
				mapToStructureType: (exportedSSAModule structureNamed: aggregateTypeName)
		].
		(moduleAttributes at: #programEntityMapToSymbol) pairsDo: [ :programEntity :globalSymbol |
			exportedSSAModule addHighLevelEntity: programEntity mapToGlobalValue: (exportedSSAModule globalNamed: globalSymbol)
		].
			
		self namedTargetCodeModules at: moduleName put: exportedSSAModule
	]
]

{ #category : #accessing }
MbndStandaloneModule >> disableSLVMOptimizations [
	^ self class disableSLVMOptimizations
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> encodeExportedSSAModuleWith: graphEncoder [
	^ Array streamContents: [ :out |
		self namedTargetCodeModules keys sorted do: [ :ssaModuleName |
			| ssaModule exportSSAModule |
			ssaModule := namedTargetCodeModules at: ssaModuleName.
			exportSSAModule := ssaModule asPublicInterfaceDeclarationModule.
			out nextPut: ssaModuleName; nextPut: {
				#module . exportSSAModule asFullSExpression.
				#programEntityMapToAggregateType . ((exportSSAModule highLevelMapToStructureType associations collect: [ :assoc |
					{ assoc key encodeGraphForMessagePackWith: graphEncoder.  assoc value name asSymbol }
					] as: Array) sorted: [:a :b | a second < b second]) flattened. 
						
				#programEntityMapToSymbol. ((exportSSAModule highLevelMapToSymbol associations collect: [ :assoc |
					{ assoc key encodeGraphForMessagePackWith: graphEncoder. assoc value asSymbol }
				] as: Array) sorted: [:a :b | a second < b second]) flattened.
			}
		]
	]
]

{ #category : #serialization }
MbndStandaloneModule >> encodeFieldsForMessagePackWith: graphEncoder [
	| resultHead resultTail |
	resultHead := {
		#name . name.
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
		#bootstrapObjects . self compilationTarget encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder
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

	self assert: name isNotNil.
	^ graphEncoder encodeObject: self type: #ReferenceModule fields: [ self name ]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> encodeModulePublicInterface [
	| graphEncoder result |
		graphEncoder := MbndSerializationGraphEncoder new
			setExportMode;
			typeMapTable: MessagePackTypeMapTable;
			targetModule: self;
			yourself.

	result := {
		#module . MbndProfiler component: #exportModulePublicInterfaceEncodeGraph with: [ 
			self encodeGraphForMessagePackWith: graphEncoder.
		].
		#exportedSSAModules . MbndProfiler component: #exportModulePublicInterfaceEncodeSSA with: [
			self encodeExportedSSAModuleWith: graphEncoder
		].
	}.

	^ MbndProfiler component: #exportModulePublicInterfaceEncodeMessagePack with: [ 
		SLVMMessagePackGraphEncoder encodeObject: result
	]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> evaluateModuleLevelFilesIfExists: fileName [
	| suffix location result |
	suffix := fileName asFileReference.
	result := false. 
	sourceLocations do: [ :each |
		location := each resolve: suffix.
		(location exists and: [ location isFile ]) ifTrue: [
			result := true.
			self evaluateFileNamedOnce: location
		] 
	].

	^ result
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> exportModulePublicInterfaceTo: outputFileName [
	| publicModuleEncodedMessage |
	publicModuleEncodedMessage := self encodeModulePublicInterface.
	
	MbndProfiler component: #exportModulePublicInterfaceStore with: [ 
		outputFileName asFileReference binaryWriteStreamDo: [ :out |
			out truncate; nextPutAll: publicModuleEncodedMessage
		]
	].
]

{ #category : #parameters }
MbndStandaloneModule >> hasExceptions [
	<compileTime>
	^ compilationEnvironment hasExceptions
]

{ #category : #parameters }
MbndStandaloneModule >> hasGPUSupport [
	<compileTime>
	^ compilationEnvironment hasGPUSupport
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionStackMap [
	<compileTime>
	^ compilationEnvironment hasGarbageCollectionStackMap
]

{ #category : #parameters }
MbndStandaloneModule >> hasGarbageCollectionSupport [
	<compileTime>
	^ compilationEnvironment hasGarbageCollectionSupport
]

{ #category : #parameters }
MbndStandaloneModule >> hasLibC [
	<compileTime>
	^ compilationEnvironment hasLibC
]

{ #category : #parameters }
MbndStandaloneModule >> hasPreciseGarbageCollector [
	<compileTime>
	^ compilationEnvironment hasPreciseGarbageCollector
]

{ #category : #parameters }
MbndStandaloneModule >> hasRuntimeTypeInformation [
	<compileTime>
	^ compilationEnvironment hasRuntimeTypeInformation
]

{ #category : #parameters }
MbndStandaloneModule >> hasStandardLibrary [
	<compileTime>
	^ compilationEnvironment hasStandardLibrary
]

{ #category : #serialization }
MbndStandaloneModule >> importModuleFrom: aModuleExportFileDefinition [
	| moduleExportFileContents decodedExportedModuleAttributes |
	moduleExportFileContents := aModuleExportFileDefinition asFileReference binaryReadStreamDo: [ :in | in contents ].
	MbndProfiler component: #importModuleDecode with: [
		decodedExportedModuleAttributes := Dictionary newFromPairs: (MbndMessagePackGraphDecoder new
			typeTable: MessagePackTypeMapTable;
			compilationTarget: self compilationTarget;
			compilationEnvironment: self compilationEnvironment;
			targetModule: self;
			decode: moduleExportFileContents).
		self assert: (decodedExportedModuleAttributes at: #module) == self.
	].

	MbndProfiler component: #importModulePostMaterialize with: [
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
	].
	
	decodedExportedModuleAttributes at: #exportedSSAModules ifPresent: [ :exportedSSAModules |			
		MbndProfiler component: #importModuleSSADecode with: [
			self decodeImportedSSAModules: (Dictionary newFromPairs: exportedSSAModules) 
		]
	]
]

{ #category : #accessing }
MbndStandaloneModule >> importedModules [
	^ importedModules ifNil: [ #() ]
]

{ #category : #accessing }
MbndStandaloneModule >> importedModules: anObject [
	importedModules := anObject
]

{ #category : #accessing }
MbndStandaloneModule >> initializeWithCompilationEnvironment: aCompilationEnvironment [
	compilationEnvironment := aCompilationEnvironment.
	sourceLocations := #().
	compilationEnvironment compilationTarget coreDefinitionsModule ifNil: [ 
		compilationEnvironment compilationTarget
			coreDefinitionsModule: self;
			initialize.
	].

	self initialize
]

{ #category : #testing }
MbndStandaloneModule >> isStandaloneModule [
	^ true
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadPackage: packageName [
	self loadedPackageStates at: packageName ifPresent: [ :state |
		state == #loading ifTrue: [ self error: 'Circular package dependency for package: {1}' format: {packageName} ].
		^ self
	] ifAbsentPut: [#loading].

	(self evaluateModuleLevelFilesIfExists: packageName asFileReference / 'package.sysmel') ifFalse: [
		self error: 'Failed to load package {1}: no sources have been found.' format: {packageName}
	].
	
	loadedPackageStates at: packageName put: #loaded.
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadPackages: packageNames [
	<compileTime>
	packageNames do: [ :each |
		self loadPackage: each
	]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadRuntimeCoreLibrary [
	^ self evaluateFileNamedOnce: MbndCoreAssets location  / 'lib' / 'kernel' / 'kernel.sysmel'. 
]

{ #category : #accessing }
MbndStandaloneModule >> loadedPackageStates [
	^ loadedPackageStates ifNil: [ loadedPackageStates := Dictionary new ]
]

{ #category : #serialization }
MbndStandaloneModule >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name.
	(encodedFields at: #definedTypesLazyFields) do: [ :each |
		each first materializeWithGraphDecoder: graphDecoder withLazyFields: (Dictionary newFromPairs: each second)
	].

	globalNamespace := encodedFields at: #globalNamespace.
	extensionMacros := encodedFields at: #extensionMacros.
	extensionOverloadedMethods := encodedFields at: #extensionOverloadedMethods.
	encodedFields at: #bootstrapObjects ifPresent: [ :bootstrapObjects |
		self compilationTarget materializeBootstrapDefinedObjectWithGraphDecoder: graphDecoder withFields: (Dictionary newFromPairs: bootstrapObjects)
	]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> monolithicSubmoduleState [
	^ { name . sourceLocations . importedModules . loadedPackageStates }
]

{ #category : #parameters }
MbndStandaloneModule >> optimizationLevel [
	^ compilationEnvironment optimizationLevel
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> restoreMonolithicSubmoduleState: state [
	name := state first.
	sourceLocations := state second.
	importedModules := state third.
	loadedPackageStates := state fourth.
]

{ #category : #accessing }
MbndStandaloneModule >> sourceLocations [
	^ sourceLocations
]

{ #category : #accessing }
MbndStandaloneModule >> sourceLocations: anObject [
	sourceLocations := anObject
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
	| lowLevelModule ssaModule outputFileReference |
	self finishSemanticAnalysis.
	ssaModule := self generateTargetCodeModule.
	outputFileReference := outputFileName asFileReference.
	
	ssaModule disableSLVMOptimizations: self disableSLVMOptimizations.
	ssaModule disableSLVMOptimizations ifFalse: [ 
		self optimizationLevel > 0 ifTrue: [ 
			ssaModule optimizeGlobalVariables
		].
	].

	MbndProfiler component: #lirCodeGeneration with: [ 
		lowLevelModule := ssaModule asLowLevelModuleWithOptimizationLevel: self optimizationLevel.
		lowLevelModule linkerArguments: linkerArguments.
	].
	
	writeMode == #assembly ifTrue: [
		^ lowLevelModule writeAssemblyToFileNamed: outputFileName
	].

	writeMode == #llvm_assembly ifTrue: [
		^ MbndProfiler component: #llvmAssemblyToFile with: [
			lowLevelModule writeIRAssemblyToFileNamed: outputFileName
		]
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
