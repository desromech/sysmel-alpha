Class {
	#name : #MbndStandaloneModule,
	#superclass : #MbndAbstractModule,
	#instVars : [
		'compilationEnvironment',
		'sourceLocations',
		'importedModules',
		'loadedPackageStates',
		'linkerArguments',
		'linkerImportModule',
		'modificationTime',
		'importedIndirectModules',
		'thirdPartyLibraryDependencies',
		'requiredResources',
		'activePackageName'
	],
	#classVars : [
		'MessagePackTypeMapTable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

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
	#ReferenceGlobalNamespace . MbndReferenceEntity .
	#ReferenceNamedChild . MbndReferenceEntity .
	#ReferenceMainChild . MbndReferenceEntity .
	#ReferenceFieldChild . MbndReferenceEntity .
	#ReferenceTemplateInstance . MbndReferenceEntity .
	#ReferenceMetaType . MbndReferenceEntity .
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

{ #category : #accessing }
MbndStandaloneModule >> activePackageName [
	^ activePackageName
]

{ #category : #adding }
MbndStandaloneModule >> addImportedIndirectModule: extraModules [
	importedIndirectModules := self importedIndirectModules , (extraModules asArray collect: [:each | each asFileReference basenameWithoutExtension ])
]

{ #category : #adding }
MbndStandaloneModule >> addImportedModules: extraModules [
	importedModules := self importedModules , extraModules asArray
]

{ #category : #accessing }
MbndStandaloneModule >> addLinkerArguments: arguments [
	self linkerArguments addAll: arguments
]

{ #category : #adding }
MbndStandaloneModule >> addResourcesDirectory: directoryName [
	| workingDirectory location |
	workingDirectory := MbndHostMessageEvaluationScope value
		ifNil: [ FileSystem workingDirectory ]
		ifNotNil: [ :scope | scope workingDirectory ].
	location := workingDirectory resolve: directoryName.
	(location exists and: [ location isDirectory ]) ifTrue: [
		| parentDir|
		parentDir := location asAbsolute canonicalize.
		self requiredResources addAll: (parentDir allChildren
			select: [ :eachFile | eachFile isFile ]
			thenCollect: [ :eachFile | {(eachFile relativeTo: parentDir) fullName . eachFile fullName} ]
		)
	]
]

{ #category : #adding }
MbndStandaloneModule >> addThirdPartyLibraryDependencies: dependenciesName [
	dependenciesName do: [ :each | self addThirdPartyLibraryDependency: each ]
]

{ #category : #adding }
MbndStandaloneModule >> addThirdPartyLibraryDependency: dependencyName [
	self compilationEnvironment validateThirdPartyDependencyName: dependencyName.
	self thirdPartyLibraryDependencies add: dependencyName
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> allImportedModules [
	"This performs a topological sort of all of the imported modules."
	| result visited |
	result := SLVMOrderedInsertionSet new.
	visited := IdentitySet new.
	visited add: self. "Do not add me to the result."
	self importedModules do: [ :each | each allImportedModulesInto: result visited: visited ].
	^ result asArray
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> allImportedModulesInto: result visited: visited [
	(visited includes: self) ifTrue: [ ^ self ].
	visited add: self.
	
	self importedModules do: [ :each |
		each allImportedModulesInto: result visited: visited
	].
	result add: self.
	^ result
	
]

{ #category : #accessing }
MbndStandaloneModule >> allLinkerArguments [
	| importedObjectFiles |
	importedObjectFiles := Set new.
	^ Array streamContents: [ :out |
		self allImportedModules do: [:each |
			each linkerImportModule ifNotNil: [ :importModule |
				| objectFile |
				objectFile := self compilationEnvironment concretizeModuleImportObjectFileName: importModule.
				(importedObjectFiles includes: objectFile) ifFalse: [ 
					out nextPut: objectFile.
					importedObjectFiles add: objectFile
				].
			].
			each importedIndirectModules do: [ :eachImportedModule |
				self compilationEnvironment fetchIndirectModuleLinkerFlags: eachImportedModule
					removeDuplicatesWith: importedObjectFiles
					into: out
			].
		
			out nextPutAll: each linkerArguments.
		].

		out nextPutAll: self linkerArguments.
	].
]

{ #category : #accessing }
MbndStandaloneModule >> allRequiredResources [
	| resourcesSet |
	resourcesSet := Set new.
	^ Array streamContents: [ :out |
		self allImportedModules do: [:each |
			each importedIndirectModules do: [ :eachImportedModule |
				self compilationEnvironment fetchIndirectModuleRequiredResources: eachImportedModule
					removeDuplicatesWith: resourcesSet
					into: out
			].
		
			each requiredResources do: [ :eachResource |
				(resourcesSet includes: eachResource) ifFalse: [
					resourcesSet add: eachResource.
					out nextPut: eachResource
				]
			].
		].

		self requiredResources do: [ :eachResource |
			(resourcesSet includes: eachResource) ifFalse: [
				resourcesSet add: eachResource.
				out nextPut: eachResource
			]
		].
	].
]

{ #category : #accessing }
MbndStandaloneModule >> allThirdPartyLibrariesLinkerArguments [
	^ Array streamContents: [ :out |
		self compilationEnvironment fetchThirdPartyLibrariesLinkerFlags: self allThirdPartyLibraryDependencies into: out.
	].
]

{ #category : #accessing }
MbndStandaloneModule >> allThirdPartyLibraryDependencies [
	| thirdPartyDepSet |
	thirdPartyDepSet := Set new.
	^ Array streamContents: [ :out |
		self allImportedModules do: [:each |
			each importedIndirectModules do: [ :eachImportedModule |
				self compilationEnvironment fetchIndirectModuleThirdPartyLibraries: eachImportedModule
					removeDuplicatesWith: thirdPartyDepSet
					into: out
			].
		
			each thirdPartyLibraryDependencies do: [ :eachDep |
				(thirdPartyDepSet includes: eachDep) ifFalse: [
					thirdPartyDepSet add: eachDep.
					out nextPut: eachDep
				]
			].
		].

		self thirdPartyLibraryDependencies do: [ :eachDep |
			(thirdPartyDepSet includes: eachDep) ifFalse: [
				thirdPartyDepSet add: eachDep.
				out nextPut: eachDep
			]
		].
	].
]

{ #category : #accessing }
MbndStandaloneModule >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
MbndStandaloneModule >> compilationTarget [
	^ compilationEnvironment compilationTarget
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> createExportedSSAModuleFor: ssaModule [
	"ssaModule compilationTarget isGPU ifTrue: [^ ssaModule ]."

	^ ssaModule asPublicInterfaceDeclarationModule
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
	^ self compilationTarget shouldDisableSLVMOptimizations
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> encodeExportedSSAModuleWith: graphEncoder [
	^ Array streamContents: [ :out |
		self namedTargetCodeModules keys sorted do: [ :ssaModuleName |
			| ssaModule exportSSAModule |
			ssaModule := namedTargetCodeModules at: ssaModuleName.
			exportSSAModule := self createExportedSSAModuleFor: ssaModule.
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
		#importedModules . self importedModules encodeGraphForMessagePackWith: graphEncoder.
		#importedIndirectModules . self importedIndirectModules encodeGraphForMessagePackWith: graphEncoder.
		#globalNamespace . self globalNamespace encodeGraphForMessagePackWith: graphEncoder.
		#extensionMacros . self extensionMacros encodeGraphForMessagePackWith: graphEncoder.
		#extensionOverloadedMethods . self extensionOverloadedMethods encodeGraphForMessagePackWith: graphEncoder.
		#externalTemplateInstances . self externalTemplateInstances encodeGraphForMessagePackWith: graphEncoder.
		#nonTrivialSpecialStructures . (self specialStructures select: [ :each | each isNonTrivial ]) asArray encodeGraphForMessagePackWith: graphEncoder.
		#linkerArguments . self linkerArguments asArray.
		#linkerImportModule . linkerImportModule .
		#thirdPartyLibraryDependencies . self thirdPartyLibraryDependencies asArray.
		#requiredResources . self requiredResources asArray.
	}.
	self importedModules ifEmpty: [
		resultTail := resultTail ,
		{
			#bootstrapObjects . self compilationTarget encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder
		}.
	].
	
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
MbndStandaloneModule >> exportExportLinkerFlagsTo: outputFileName [
	outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self allLinkerArguments do: [ :each |
			out nextPutAll: each; lf
		].
	]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> exportModuleDependenciesTo: outputFileName [
	outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self allImportedModules asArray do: [ :each |
			self assert: each ~~ self.
			out nextPutAll: 'module:'; nextPutAll: each name; lf
		].
		self importedIndirectModules asArray do: [ :each |
			out nextPutAll: 'imodule:'; nextPutAll: each; lf
		].
		self evaluatedFileSet asArray sorted do: [ :each |
			out nextPutAll: 'file:'; nextPutAll: each asFileReference asAbsolute canonicalize fullName; lf
		].
	]
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

{ #category : #writing }
MbndStandaloneModule >> generateLowLevelTargetCodeModule [
	| ssaModule |
	ssaModule := self generateTargetCodeModule.
	ssaModule disableSLVMOptimizations: self disableSLVMOptimizations.
	ssaModule disableSLVMOptimizations ifFalse: [ 
		self optimizationLevel > 0 ifTrue: [ 
			ssaModule optimizeGlobalVariables
		].
	].

	^ MbndProfiler component: #lirCodeGeneration with: [ 
		ssaModule asLowLevelModuleWithOptimizationLevel: self optimizationLevel.
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
MbndStandaloneModule >> importIndirectModuleFrom: aModuleExportFileDefinition [
	self addImportedIndirectModule: aModuleExportFileDefinition
]

{ #category : #serialization }
MbndStandaloneModule >> importModuleFrom: aModuleExportFileDefinition [
	| moduleExportFileReference moduleExportFileContents decodedExportedModuleAttributes |
	importedModules := #().
	moduleExportFileReference := aModuleExportFileDefinition asFileReference.
	modificationTime := moduleExportFileReference modificationTime.
	moduleExportFileContents := moduleExportFileReference binaryReadStreamDo: [ :in | in contents ].
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

		self externalTemplateInstances do: [ :each |
			each second postMaterializeSetupParent: each first withModule: self
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
MbndStandaloneModule >> importedIndirectModules [
	^ importedIndirectModules ifNil: [ #() ]
]

{ #category : #accessing }
MbndStandaloneModule >> importedIndirectModules: anObject [
	importedIndirectModules := anObject
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

{ #category : #accessing }
MbndStandaloneModule >> linkerArguments [
	^ linkerArguments ifNil: [ linkerArguments := OrderedCollection new ]
]

{ #category : #accessing }
MbndStandaloneModule >> linkerImportModule [
	^ linkerImportModule
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadPackage: packageName [
	| oldActivePackageName |
	self loadedPackageStates at: packageName ifPresent: [ :state |
		state == #loading ifTrue: [ self error: 'Circular package dependency for package: {1}' format: {packageName} ].
		^ self
	] ifAbsentPut: [#loading].

	oldActivePackageName := activePackageName.
	[
		activePackageName := packageName.
		(self evaluateModuleLevelFilesIfExists: packageName asFileReference / 'package.sysmel') ifFalse: [
			self error: 'Failed to load package {1}: no sources have been found.' format: {packageName}
		].
	] ensure: [ activePackageName := oldActivePackageName ].
	loadedPackageStates at: packageName put: #loaded.
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> loadPackages: packageNames [
	<compileTime>
	packageNames do: [ :each |
		self loadPackage: each
	]
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

	importedModules := encodedFields at: #importedModules.
	importedIndirectModules := encodedFields at: #importedIndirectModules.
	globalNamespace := encodedFields at: #globalNamespace.
	extensionMacros := encodedFields at: #extensionMacros.
	extensionOverloadedMethods := encodedFields at: #extensionOverloadedMethods.
	externalTemplateInstances := encodedFields at: #externalTemplateInstances.
	linkerArguments := encodedFields at: #linkerArguments.
	linkerImportModule := encodedFields at: #linkerImportModule ifAbsent: [nil].
	thirdPartyLibraryDependencies := encodedFields at: #thirdPartyLibraryDependencies ifAbsent: [ nil ].
	requiredResources := encodedFields at: #requiredResources ifAbsent: [ nil ].

	encodedFields at: #bootstrapObjects ifPresent: [ :bootstrapObjects |
		self compilationTarget materializeBootstrapDefinedObjectWithGraphDecoder: graphDecoder withFields: (Dictionary newFromPairs: bootstrapObjects)
	]
]

{ #category : #accessing }
MbndStandaloneModule >> modificationTime [
	^ modificationTime
]

{ #category : #accessing }
MbndStandaloneModule >> modificationTime: anObject [
	modificationTime := anObject
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
MbndStandaloneModule >> outputExportResourcesListTo: outputFileName [
	outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self allRequiredResources do: [ :each |
			out nextPutAll: each first; lf.
			out nextPutAll: each second; lf.
		].
	]
]

{ #category : #'as yet unclassified' }
MbndStandaloneModule >> outputExportThirdPartyPackagesTo: outputFileName [
	outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self allThirdPartyLibraryDependencies do: [ :each |
			out nextPutAll: each; lf
		].
	]
]

{ #category : #accessing }
MbndStandaloneModule >> requiredResources [
	^ requiredResources ifNil: [requiredResources := OrderedCollection new]
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

{ #category : #accessing }
MbndStandaloneModule >> thirdPartyLibraryDependencies [
	^ thirdPartyLibraryDependencies ifNil: [ thirdPartyLibraryDependencies := OrderedCollection new ]
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
	outputFileReference := outputFileName asFileReference.
	lowLevelModule := self generateLowLevelTargetCodeModule.
	lowLevelModule linkerArguments: self allLinkerArguments , self allThirdPartyLibrariesLinkerArguments.
	linkerImportModule isNil ifTrue: [
		(#(assembly llvm_assembly object) includes: writeMode) ifTrue: [ 
				linkerImportModule := outputFileReference basename
		] ifFalse: [ 
			writeMode = #shared ifTrue: [
				ssaModule compilationTarget sharedObjectsAreAlsoImports ifTrue: [ 
					linkerImportModule := outputFileReference basename
				] ifFalse: [
					"TODO: Add the required flags/tools for generating the .lib for the Windows dll"
					self halt
				]
			].
		].
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

	writeMode == #objectLib ifTrue: [
		^ lowLevelModule writeObjectLibToFileNamed: outputFileName
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
MbndStandaloneModule >> writeObjectLibToFileNamed: outputFileName [
	^ self writeMode: #objectLib toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeObjectToFileNamed: outputFileName [
	^ self writeMode: #object toFileNamed: outputFileName
]

{ #category : #writing }
MbndStandaloneModule >> writeSharedToFileNamed: outputFileName [
	^ self writeMode: #shared toFileNamed: outputFileName
]
