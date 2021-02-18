Class {
	#name : #MbndCompilationEnvironment,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'settings',
		'compilationTarget',
		'coreModule',
		'linkerArguments',
		'currentModule',
		'loadedModuleDictionary',
		'loadedModules',
		'moduleTranslationMode',
		'currentModuleStack',
		'outputMode',
		'hasBeginModule',
		'importedModuleModificationTimeCache',
		'loadedThirdPartyLibrarySpecs',
		'hasSeparateDistFolders'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> compilationTarget: aCompilationTarget [
	^ self basicNew
		initializeWithCompilationTarget: aCompilationTarget;
		yourself

]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> coreModuleName [
	^ #'Sysmel.Core'
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_arm [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_arm
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_arm64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_arm64
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv5 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv5
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv6 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv6
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv6k [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv6k
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv6m [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv6m
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv7 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv7
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv7a [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv7a
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_armv7m [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_armv7m
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_mipsel [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_mipsel
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_webAssembly [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_webAssembly
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_webAssembly32 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_webAssembly32
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_webAssembly64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_webAssembly64
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_x86 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_x86_64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86_64
]

{ #category : #serialization }
MbndCompilationEnvironment class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	self assert: objectType = #CompilationEnvironment.
	graphDecoder registerObjectInstance: graphDecoder compilationEnvironment.
	graphDecoder decodeNext.
	^ graphDecoder compilationEnvironment
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> sasm_x86 [
	^ self compilationTarget: MbndSlovimCompilationTarget sasm_x86
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> sasm_x86_64 [
	^ self compilationTarget: MbndSlovimCompilationTarget sasm_x86_64
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> spirv_vulkan [
	^ self compilationTarget: MbndSlovimCompilationTarget spirv_vulkan
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> withSettings: aCompilationTarget [
	^ self basicNew
		initializeWithSettings: aCompilationTarget;
		yourself

]

{ #category : #parameters }
MbndCompilationEnvironment >> addLinkerArguments: arguments [
	<compileTime>
	self currentModule addLinkerArguments: arguments
]

{ #category : #adding }
MbndCompilationEnvironment >> addLoadedModule: module [
	self assert: module isNotNil.
	self loadedModules add: module.
	module name ifNotNil: [ :name | self loadedModuleDictionary at: name put: module ].
]

{ #category : #initialization }
MbndCompilationEnvironment >> addModuleSourceLocation: location [
	settings addModuleSourceLocation: location
]

{ #category : #adding }
MbndCompilationEnvironment >> addNativeLibraryDependencies: dependenciesName [
	<compileTime>
	self currentModule addNativeLibraryDependencies: dependenciesName
]

{ #category : #adding }
MbndCompilationEnvironment >> addNativeLibraryDependency: dependencyName [
	<compileTime>
	self currentModule addNativeLibraryDependency: dependencyName
]

{ #category : #parameters }
MbndCompilationEnvironment >> addResourcesDirectory: directory [
	<compileTime>
	self currentModule addResourcesDirectory: directory
]

{ #category : #adding }
MbndCompilationEnvironment >> addThirdPartyLibraryDependencies: dependenciesName [
	<compileTime>
	self currentModule addThirdPartyLibraryDependencies: dependenciesName
]

{ #category : #adding }
MbndCompilationEnvironment >> addThirdPartyLibraryDependency: dependencyName [
	<compileTime>
	self currentModule addThirdPartyLibraryDependency: dependencyName
]

{ #category : #evaluation }
MbndCompilationEnvironment >> analyzeAndEvaluateParsedSource: parsedSource [
	^ self validCurrentModule analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #'semantic analysis' }
MbndCompilationEnvironment >> analyzeReferenceNode: referenceNode with: analyzer [
	^ (self asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: referenceNode;
		yourself
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> assembly [
	self outputMode: #assembly
]

{ #category : #'module import' }
MbndCompilationEnvironment >> beginModule: moduleName [
	hasBeginModule := true.
	self pushCurrentModule.
	self validCurrentModule name: moduleName.
	self addLoadedModule: currentModule.
]

{ #category : #initialization }
MbndCompilationEnvironment >> buildDirectory: anOutputDirectory [
	settings buildDirectory: anOutputDirectory

]

{ #category : #accessing }
MbndCompilationEnvironment >> compilationTarget [
	^ compilationTarget
]

{ #category : #'module import' }
MbndCompilationEnvironment >> compileModuleNamed: moduleName [
	| importedModuleSourceLocations location resultModule isCoreModule |
	importedModuleSourceLocations := OrderedCollection new.
	self moduleSourceLocations do: [ :each | 
		location := each / moduleName. 
		(location exists and: [ location isDirectory ]) ifTrue: [
			importedModuleSourceLocations add: location
		].
	].

	importedModuleSourceLocations ifEmpty: [
		self error: 'Cannot import or compile module named {1}' format: { moduleName }
	].


	self hasMonolithicTranslationMode ifTrue: [ self pushCurrentModule ].
	self validCurrentModule
		name: moduleName;
		sourceLocations: importedModuleSourceLocations asArray.
	self addLoadedModule: currentModule.
	resultModule := currentModule evaluateModuleLevelFilesIfExists: 'module.sysmel' asFileReference.
	self hasMonolithicTranslationMode ifTrue: [self popCurrentModule ].
	^ resultModule

]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> concretizeModuleImportObjectFileName: aFileName [
	| fileRef testFileRef |
	fileRef := aFileName asFileReference.
	fileRef exists ifTrue: [ ^ fileRef asAbsolute fullName ].
	
	testFileRef := self validBuildObjectDirectory resolve: fileRef.
	testFileRef exists ifTrue: [ ^ testFileRef asAbsolute fullName ].
	self error: 'Failed required import module object file {1}.' format: { aFileName }
]

{ #category : #accessing }
MbndCompilationEnvironment >> coreModule [
	^ coreModule
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> coreModuleName [
	^ self class coreModuleName
]

{ #category : #accessing }
MbndCompilationEnvironment >> cpu: cpu [
	compilationTarget cpu: cpu.
]

{ #category : #accessing }
MbndCompilationEnvironment >> currentModule [
	^ currentModule
]

{ #category : #initialization }
MbndCompilationEnvironment >> defaultModuleTranslationMode [
	self object
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> dll [
	self shared
]

{ #category : #'module translation mode' }
MbndCompilationEnvironment >> dllPerModule [
	moduleTranslationMode := #dll.
]

{ #category : #'module import' }
MbndCompilationEnvironment >> endModule [
	self popCurrentModule
]

{ #category : #evaluation }
MbndCompilationEnvironment >> evaluateFileNamed: fileName [
	^ self validCurrentModule evaluateFileNamed: fileName
]

{ #category : #evaluation }
MbndCompilationEnvironment >> evaluateFileNamedOnce: fileName [
	hasBeginModule ifFalse: [
		self beginModule: fileName asFileReference basenameWithoutExtension asSymbol
	].

	^ self validCurrentModule evaluateFileNamedOnce: fileName
]

{ #category : #evaluation }
MbndCompilationEnvironment >> evaluateLanguage: languageName source: sourceString [
	^ self validCurrentModule evaluateLanguage: languageName source: sourceString
]

{ #category : #evaluation }
MbndCompilationEnvironment >> evaluateRuntimeCoreLibrary [
	coreModule loadRuntimeCoreLibrary
]

{ #category : #'module import' }
MbndCompilationEnvironment >> executable [
	self outputMode: #executable
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> fetchIndirectModuleLinkerFlags: indirectModule removeDuplicatesWith: importedObjectFiles into: out [
	| lflagsFileReference indirectModuleOutput objectFileName |

	indirectModuleOutput := self findModuleObjectFileReferenceFor: indirectModule.
	indirectModuleOutput exists ifTrue: [
		objectFileName := indirectModuleOutput asFileReference fullName.
		(importedObjectFiles includes: objectFileName) ifFalse: [ 
			out nextPut: objectFileName.
			importedObjectFiles add: objectFileName
		].
	].

	lflagsFileReference := self findImportModuleLFlagsFileReferenceFor: indirectModule.
	lflagsFileReference exists ifTrue: [
		lflagsFileReference contents linesDo: [ :each |
			(importedObjectFiles includes: each) ifFalse: [ 
				out nextPut: each.
				importedObjectFiles add: each
			]
		]
	].
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> fetchIndirectModuleRequiredResources: indirectModule removeDuplicatesWith: resourcesSet into: out [
	| rlstFileReference |
	rlstFileReference := self findImportModuleRequiredResourcesFileReferenceFor: indirectModule.
	rlstFileReference exists ifTrue: [
		rlstFileReference contents lines pairsDo: [ :first :second |
			| resourceFileSpec |
			resourceFileSpec := { first . second }.
			(resourcesSet includes: resourceFileSpec) ifFalse: [ 
				out nextPut: resourceFileSpec.
				resourcesSet add: resourceFileSpec
			]
		]
	].
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> fetchIndirectModuleThirdPartyLibraries: indirectModule removeDuplicatesWith: thirdPartLibrarySet into: out [
	| plstFileReference |
	plstFileReference := self findImportModuleThirdPartyLibrariesFileReferenceFor: indirectModule.
	plstFileReference exists ifTrue: [
		plstFileReference contents linesDo: [ :thirdPartyLibraryName |
			(thirdPartLibrarySet includes: thirdPartyLibraryName) ifFalse: [ 
				out nextPut: thirdPartyLibraryName.
				thirdPartLibrarySet add: thirdPartyLibraryName
			]
		]
	].
]

{ #category : #adding }
MbndCompilationEnvironment >> fetchThirdPartyLibrariesLinkerFlags: thirdPartyLibrariesName into: outputArray [
	thirdPartyLibrariesName ifEmpty: [ ^ self ].
	thirdPartyLibrariesName do: [ :each |
		self fetchThirdPartyLibraryLinkerFlags: each into: outputArray
	].
]

{ #category : #adding }
MbndCompilationEnvironment >> fetchThirdPartyLibraryLinkerFlags: thirdPartyLibraryName into: outputArray [
	| spec |
	spec := self getThirdPartyLibrarySpec: thirdPartyLibraryName.
	spec makeExportedLibraries.
	outputArray nextPutAll: spec allExportedLibrariesLinkerArguments
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleFileReferenceFor: moduleName [
	^ self validBuildSysmelCacheDirectory / (moduleName , '.smpmodule')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleLFlagsFileReferenceFor: moduleName [
	^ self validBuildSysmelCacheDirectory / (moduleName , '.smpmodule.lflags')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleRequiredResourcesFileReferenceFor: moduleName [
	^ self validBuildSysmelCacheDirectory / (moduleName , '.smpmodule.rlst')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleThirdPartyLibrariesFileReferenceFor: moduleName [
	^ self validBuildSysmelCacheDirectory / (moduleName , '.smpmodule.plst')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findModuleObjectFileReferenceFor: moduleName [
	^ self validBuildObjectDirectory / (moduleName , self importedModuleExtension)
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> finishAndEmitModule [
	currentModule ifNil: [ ^ self ].
	^ (#(llvm_assembly assembly object objectLib) includes: outputMode) ifTrue: [ 
		self finishAndEmitModuleInOutputDirectory: self validBuildObjectDirectory cacheDirectory: self validBuildSysmelCacheDirectory
	] ifFalse: [ 
		self finishAndEmitModuleInOutputDirectory: self validBuildOutputDirectory cacheDirectory: self validBuildSysmelCacheDirectory
	].

]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> finishAndEmitModuleInOutputDirectory: outputDirectory cacheDirectory: cacheDirectory [
	| outputFileName outputFileReference result outputShaderFileName |
	currentModule ifNil: [ ^ self ].
	self finishSemanticAnalysis.
	
	outputFileName := self validCurrentModule name , (compilationTarget extensionForModuleOutputMode: outputMode).
	outputShaderFileName := self validCurrentModule name , (compilationTarget extensionForEmbeddedShaderCopy).
	outputFileReference := outputDirectory / outputFileName.

	result := self validCurrentModule
		embeddedShaderCopyOutputFile: outputDirectory / outputShaderFileName;
		writeMode: outputMode toFileNamed: outputFileReference.
	cacheDirectory ensureCreateDirectory.
	self writeExportModuleFor: cacheDirectory / outputFileName.
	^ result
]

{ #category : #'module import' }
MbndCompilationEnvironment >> finishSemanticAnalysis [
	self validCurrentModule finishSemanticAnalysis
]

{ #category : #accessing }
MbndCompilationEnvironment >> floatAbiName: fpu [
	compilationTarget floatAbiName: fpu.
]

{ #category : #accessing }
MbndCompilationEnvironment >> floatingPointModel: fpModel [
	compilationTarget floatingPointModel: fpModel
]

{ #category : #accessing }
MbndCompilationEnvironment >> fpu: fpu [
	compilationTarget fpu: fpu.
]

{ #category : #parameters }
MbndCompilationEnvironment >> freestanding [
	<compileTime>
	^ self
		noLibC;
		noRTTI.
]

{ #category : #writing }
MbndCompilationEnvironment >> generateLowLevelTargetCodeModule [
	^ self validCurrentModule generateLowLevelTargetCodeModule
]

{ #category : #evaluation }
MbndCompilationEnvironment >> getLanguageNamedFromCache: languageName [
	^ self validCurrentModule getLanguageNamedFromCache: languageName
]

{ #category : #'module import' }
MbndCompilationEnvironment >> getLastModificationTimeOfModule: dependencyName [
	| result importModuleFileReference depsFileReference |
	
	importedModuleModificationTimeCache at: dependencyName ifPresent: [ :found | ^ found ] ifAbsentPut: [ DateAndTime now ].
	
	importModuleFileReference := self findImportModuleFileReferenceFor: dependencyName.
	importModuleFileReference exists ifFalse: [ ^ importedModuleModificationTimeCache at: dependencyName ].
	
	result := importModuleFileReference modificationTime.
	
	depsFileReference := importModuleFileReference withExtension: importModuleFileReference extension , '.deps'.
	depsFileReference exists ifFalse: [
		importedModuleModificationTimeCache at: dependencyName put: result.
		^ result
	].

	result := result max: depsFileReference modificationTime.
	(self parseModificationTimesOfDependencies: depsFileReference contents) do: [ :each |
		result := result max: each.
	].

	importedModuleModificationTimeCache at: dependencyName put: result.
	^ result
]

{ #category : #adding }
MbndCompilationEnvironment >> getThirdPartyLibrarySpec: thirdPartyLibraryName [
	^ self loadedThirdPartyLibrarySpecs at: thirdPartyLibraryName ifAbsentPut: [
		self wbtEnvironment loadPackageNamed: thirdPartyLibraryName
	]
]

{ #category : #testing }
MbndCompilationEnvironment >> hasConservativeGarbageCollector [
	^ self hasGarbageCollectionSupport and: [(
		self hasPreciseGarbageCollector or: [
		self hasGarbageCollectionStackMap or: [
		self hasNullGarbageCollector or: [
		self hasReferenceCountingCollector ] ] ] ) not
	]
]

{ #category : #testing }
MbndCompilationEnvironment >> hasDLLTranslationMode [
	^ moduleTranslationMode = #dll.
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasExceptions [
	^ settings hasExceptions
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasExceptions: aBoolean [
	<compileTime>
	settings hasExceptions: aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGPUSupport [
	<compileTime>
	^ settings hasGPUSupport
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectedRuntime [
	<compileTime>
	^ self hasRuntimeTypeInformation and: [self hasGarbageCollectionSupport]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionStackMap [
	<compileTime>
	^ settings hasGarbageCollectionStackMap
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionStackMap: aBoolean [
	<compileTime>
	settings hasGarbageCollectionStackMap: aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionSupport [
	<compileTime>
	^ settings hasGarbageCollectionSupport
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionSupport: aBoolean [
	<compileTime>
	settings hasGarbageCollectionSupport: aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasLibC [
	<compileTime>
	^ settings hasLibC
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasLibC: aBoolean [
	<compileTime>
	settings hasLibC: aBoolean
]

{ #category : #testing }
MbndCompilationEnvironment >> hasMonolithicTranslationMode [
	^ moduleTranslationMode = #monolithic.
]

{ #category : #testing }
MbndCompilationEnvironment >> hasNullGarbageCollector [
	<compileTime>
	"^ self compilationTarget isWebAssembly or: [ self compilationTarget isX86 not or: [self compilationTarget isLinux not]]"
	^ false
]

{ #category : #testing }
MbndCompilationEnvironment >> hasObjectTranslationMode [
	^ moduleTranslationMode = #object.
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasPreciseGarbageCollector [
	^ "self compilationTarget isLinux not" true
]

{ #category : #testing }
MbndCompilationEnvironment >> hasReferenceCountingCollector [
	<compileTime>
	^ false
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasRuntimeTypeInformation [
	<compileTime>
	^ settings hasRuntimeTypeInformation
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasRuntimeTypeInformation: aBoolean [
	<compileTime>
	settings hasRuntimeTypeInformation: aBoolean
]

{ #category : #'module import' }
MbndCompilationEnvironment >> hasSeparateDistFolders [
	^ hasSeparateDistFolders ifNil: [ hasSeparateDistFolders := false ]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> hasSeparateDistFolders: aBoolean [
	^ hasSeparateDistFolders := aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasStandardLibrary [
	<compileTime>
	^ settings hasStandardLibrary
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasStandardLibrary: aBoolean [
	<compileTime>
	settings hasStandardLibrary: aBoolean
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importIndirectModuleFrom: moduleExportFileName [
	(self hasMonolithicTranslationMode or: [currentModule == coreModule])
		ifTrue: [ ^ self importModuleFrom: moduleExportFileName ].
	^ self validCurrentModule
		importIndirectModuleFrom: moduleExportFileName.
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importIndirectModuleNamed: moduleName [
	^ self loadedModuleDictionary at: moduleName ifAbsent: [
		self importOrCompileModuleNamed: moduleName indirectDependency: true
	]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importIndirectModulesNamed: moduleNames [
	moduleNames do: [ :each | self importIndirectModuleNamed: each ]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importModuleFrom: moduleExportFileName [
	| isCoreModule oldLoadedModuleCount importedModule |
	isCoreModule := currentModule == coreModule.
	oldLoadedModuleCount := self loadedModules size. 
	isCoreModule ifFalse: [ self pushCurrentModule ].
	
	self validCurrentModule
		importModuleFrom: moduleExportFileName.
	importedModule := currentModule.
	"Transcript show: self validCurrentModule name; space; show: self validCurrentModule importedModules; cr."
	self addLoadedModule: currentModule.
	currentModule := nil.
	
	isCoreModule ifFalse: [ self popCurrentModule ].
	
	currentModule ifNotNil: [
		currentModule addImportedModules: (self loadedModules allButFirst: oldLoadedModuleCount).
		"Transcript show: currentModule name; show: ' newImports '; show: currentModule importedModules ; cr."
	].
	^ importedModule
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importModuleNamed: moduleName [
	^ self loadedModuleDictionary at: moduleName ifAbsent: [
		self importOrCompileModuleNamed: moduleName.
	]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importModulesNamed: moduleNames [
	moduleNames do: [ :each | self importModuleNamed: each ]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importOrCompileModuleNamed: moduleName [
	^ self importOrCompileModuleNamed: moduleName indirectDependency: false
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importOrCompileModuleNamed: moduleName indirectDependency: isIndirectDependency [
	| importModuleFileReference |
	self hasMonolithicTranslationMode ifTrue: [ ^ self compileModuleNamed: moduleName ].

	importModuleFileReference := self validateDependencyModuleIsUpdated: moduleName indirectDependency: isIndirectDependency.	
	^ isIndirectDependency
		ifTrue: [self importIndirectModuleFrom: importModuleFileReference]
		ifFalse: [self importModuleFrom: importModuleFileReference]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importedModuleExtension [
	^ self compilationTarget extensionForModuleOutputMode: #object
]

{ #category : #initialization }
MbndCompilationEnvironment >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	settings ifNil: [ 
		settings := MbndCompilationEnvironmentSettings new.
		settings compilationTarget: aCompilationTarget.
	].
	importedModuleModificationTimeCache := Dictionary new.
	outputMode := #executable.
	hasBeginModule := false.

	coreModule := MbndStandaloneModule for: self.
	currentModuleStack := OrderedCollection new.
	currentModule := coreModule.
	self defaultModuleTranslationMode.
]

{ #category : #initialization }
MbndCompilationEnvironment >> initializeWithSettings: theSettings [
	settings := theSettings.
	self initializeWithCompilationTarget: settings compilationTarget
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> llvmAssembly [
	self outputMode: #llvm_assembly
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> llvmBitcode [
	self outputMode: #llvm_bitcode
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> loadPackage: packageName [
	<compileTime>
	^ self validCurrentModule loadPackage: packageName
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> loadPackages: packageNames [
	<compileTime>
	^ self validCurrentModule loadPackages: packageNames
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> loadRuntimeCoreLibrary [
	self importModuleNamed: self coreModuleName
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModuleDictionary [
	^ loadedModuleDictionary ifNil: [ loadedModuleDictionary := Dictionary new ]
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModules [
	^ loadedModules ifNil: [ loadedModules := OrderedCollection new ]
]

{ #category : #adding }
MbndCompilationEnvironment >> loadedThirdPartyLibrarySpecs [
	^ loadedThirdPartyLibrarySpecs ifNil: [ loadedThirdPartyLibrarySpecs := Dictionary new ]
]

{ #category : #accessing }
MbndCompilationEnvironment >> moduleSourceLocations [
	^ settings moduleSourceLocations
]

{ #category : #adding }
MbndCompilationEnvironment >> moduleSourceLocations: theSourceLocations [
	settings moduleSourceLocations: theSourceLocations
]

{ #category : #accessing }
MbndCompilationEnvironment >> moduleTranslationMode [
	^ moduleTranslationMode
]

{ #category : #accessing }
MbndCompilationEnvironment >> moduleTranslationMode: anObject [
	moduleTranslationMode := anObject
]

{ #category : #'module translation mode' }
MbndCompilationEnvironment >> monolithic [
	moduleTranslationMode := #monolithic.
]

{ #category : #'module import' }
MbndCompilationEnvironment >> newCompilationEnvironmentForCleanModuleBuilding [
	| result cleanTarget |
	cleanTarget := compilationTarget asCleanCompilationTarget.
	result := self class compilationTarget: cleanTarget.
	result
		moduleTranslationMode: moduleTranslationMode;
		outputMode: self outputModeForDependencies;
		settings: (settings copy compilationTarget: cleanTarget).

	^ result.
]

{ #category : #evaluation }
MbndCompilationEnvironment >> newSourceEvaluationScopeForLanguageNamed: aLanguage [
	^ self validCurrentModule newSourceEvaluationScopeForLanguageNamed: aLanguage
]

{ #category : #parameters }
MbndCompilationEnvironment >> noExceptions [
	<compileTime>
	settings noExceptions
]

{ #category : #parameters }
MbndCompilationEnvironment >> noGC [
	<compileTime>
	settings noGC
]

{ #category : #parameters }
MbndCompilationEnvironment >> noLibC [
	<compileTime>
	settings noLibC
]

{ #category : #parameters }
MbndCompilationEnvironment >> noRTTI [
	<compileTime>
	settings noRTTI
]

{ #category : #parameters }
MbndCompilationEnvironment >> noStandardLibrary [
	<compileTime>
	settings noStandardLibrary
]

{ #category : #initialization }
MbndCompilationEnvironment >> noStandardModuleSourceLocations [
	settings noStandardModuleSourceLocations
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> object [
	self outputMode: #object.
]

{ #category : #'module import' }
MbndCompilationEnvironment >> objectLib [
	self outputMode: #objectLib
]

{ #category : #'module translation mode' }
MbndCompilationEnvironment >> objectPerModule [
	moduleTranslationMode := #object.
]

{ #category : #parameters }
MbndCompilationEnvironment >> optimizationLevel [
	^ settings optimizationLevel
]

{ #category : #parameters }
MbndCompilationEnvironment >> optimizationLevel: anInteger [
	^ settings optimizationLevel: anInteger
]

{ #category : #accessing }
MbndCompilationEnvironment >> outputMode [
	^ outputMode
]

{ #category : #accessing }
MbndCompilationEnvironment >> outputMode: anObject [
	outputMode := anObject
]

{ #category : #accessing }
MbndCompilationEnvironment >> outputModeForDependencies [
	outputMode = #executable ifTrue: [
		self hasObjectTranslationMode ifTrue: [ ^ #object ].
		self hasDLLTranslationMode ifTrue: [ ^ #shared ].
	].

	^ outputMode
]

{ #category : #'module import' }
MbndCompilationEnvironment >> parseModificationTimeOfDependency: each [
	| typeDelimiterPosition dependencyType dependencyName dependencyFileRef |
	typeDelimiterPosition := each indexOf: $:.
	dependencyType := each first: typeDelimiterPosition - 1.
	dependencyName := each allButFirst: typeDelimiterPosition.
	
	dependencyFileRef := nil.
	dependencyType = 'file' ifTrue: [ 
		dependencyFileRef := dependencyName asFileReference.
	].
	dependencyType = 'module' ifTrue: [ 
		^ self getLastModificationTimeOfModule: dependencyName
	].
	dependencyType = 'imodule' ifTrue: [ 
		self validateIndirectModuleIsUpdated: dependencyName.
		^ nil
	].
	(dependencyFileRef isNil or: [dependencyFileRef exists not]) ifTrue: [ 
		^ DateAndTime now
	].

	^ dependencyFileRef modificationTime
]

{ #category : #'module import' }
MbndCompilationEnvironment >> parseModificationTimesOfDependencies: dependencies [
	^ dependencies lines collect: [ :each | self parseModificationTimeOfDependency: each ]
		thenSelect: [ :each | each isNotNil ]
]

{ #category : #private }
MbndCompilationEnvironment >> popCurrentModule [
	self hasMonolithicTranslationMode ifTrue: [
		| oldState |
		oldState := currentModuleStack last.
		currentModule restoreMonolithicSubmoduleState: oldState.
		currentModuleStack removeLast.
		^ self.
	].

	currentModule := currentModuleStack last.
	currentModuleStack removeLast.
]

{ #category : #private }
MbndCompilationEnvironment >> pushCurrentModule [
	self hasMonolithicTranslationMode ifTrue: [ 
		currentModuleStack add: currentModule monolithicSubmoduleState.
		^ self
	].

	currentModuleStack add: currentModule.
	currentModule := nil.
]

{ #category : #'module import' }
MbndCompilationEnvironment >> separateDistFolders [
	self hasSeparateDistFolders: true
]

{ #category : #accessing }
MbndCompilationEnvironment >> setForEmbeddedPAL [
	compilationTarget setForEmbeddedPAL.
]

{ #category : #accessing }
MbndCompilationEnvironment >> setForLinux [
	compilationTarget setForLinux.
]

{ #category : #accessing }
MbndCompilationEnvironment >> setForOSX [
	compilationTarget setForOSX.
]

{ #category : #accessing }
MbndCompilationEnvironment >> setForWindows [
	compilationTarget setForWindows.
]

{ #category : #accessing }
MbndCompilationEnvironment >> setNoExceptionModel [
	compilationTarget setNoExceptionModel
]

{ #category : #accessing }
MbndCompilationEnvironment >> settings [
	^ settings
]

{ #category : #accessing }
MbndCompilationEnvironment >> settings: theSettings [
	settings := theSettings
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> shared [
	self outputMode: #shared
]

{ #category : #'module import' }
MbndCompilationEnvironment >> shouldCompileModule: moduleName withFileReference: importModuleFileReference [
	importModuleFileReference exists ifFalse: [ ^ true ].
	
	^ (self getLastModificationTimeOfModule: moduleName) > importModuleFileReference modificationTime.

]

{ #category : #accessing }
MbndCompilationEnvironment >> thirdPartyLibrarySpecLocations [
	^ settings thirdPartyLibrarySpecLocations
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> useExplicitSJLJ [
	compilationTarget setNoExceptionModel
]

{ #category : #parameters }
MbndCompilationEnvironment >> useLibC [
	<compileTime>
	^ settings useLibC
]

{ #category : #parameters }
MbndCompilationEnvironment >> useLibC: aBoolean [
	<compileTime>
	settings useLibC: aBoolean
]

{ #category : #initialization }
MbndCompilationEnvironment >> validBuildCacheDirectory [
	^ self wbtEnvironment validBuildCacheDirectory
]

{ #category : #initialization }
MbndCompilationEnvironment >> validBuildObjectDirectory [
	^ self wbtEnvironment validBuildObjectDirectory
]

{ #category : #initialization }
MbndCompilationEnvironment >> validBuildOutputDirectory [
	^ self wbtEnvironment validBuildOutputDirectory
]

{ #category : #initialization }
MbndCompilationEnvironment >> validBuildResourcesDirectory [
	^ self wbtEnvironment validBuildResourcesDirectory
]

{ #category : #initialization }
MbndCompilationEnvironment >> validBuildSysmelCacheDirectory [
	^ self wbtEnvironment validBuildSysmelCacheDirectory ensureCreateDirectory; yourself
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validCurrentModule [
	currentModule ifNil: [
		currentModule := (MbndStandaloneModule for: self)
			importedModules: self loadedModules asArray;
			yourself
	].

	^ currentModule
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validateDependencyModuleIsUpdated: moduleName indirectDependency: isIndirectDependency [
	| moduleDependencyTarget sysmelModuleTarget |
	moduleDependencyTarget := self wbtEnvironment 	getOrLoadSysmelModulePackage: moduleName.
	sysmelModuleTarget := moduleDependencyTarget sysmelModuleTarget.
	isIndirectDependency ifFalse: [
		sysmelModuleTarget ensureIsBuilt
	].

	^ sysmelModuleTarget importModuleFileReference

]

{ #category : #'module import' }
MbndCompilationEnvironment >> validateIndirectModuleIsUpdated: moduleName [
	^ self validateDependencyModuleIsUpdated: moduleName
]

{ #category : #adding }
MbndCompilationEnvironment >> validateThirdPartyDependencyName: dependencyName [
	settings thirdPartyLibrarySpecLocations do: [ :each |
		| folderName |
		folderName := each / dependencyName.
		(folderName exists and: [ folderName isDirectory ]) ifTrue: [
			^ self
		]
	].

	self error: 'Failed to validate third party dependency named "{1}".' format: { dependencyName }
]

{ #category : #accessing }
MbndCompilationEnvironment >> wbtEnvironment [
	^ settings wbtEnvironment
]

{ #category : #initialization }
MbndCompilationEnvironment >> withDebugInformation [
	compilationTarget withDebugInformation
]

{ #category : #initialization }
MbndCompilationEnvironment >> withPositionIndependentCode [
	compilationTarget withPositionIndependentCode
]

{ #category : #writing }
MbndCompilationEnvironment >> writeAssemblyToFileNamed: outputFileName [
	^ self validCurrentModule writeAssemblyToFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeExecutableToFileNamed: outputFileName [
	^ self validCurrentModule writeExecutableToFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeExportModuleFor: outputFileName [
	| outputFileReference outputExportModuleFileReference |
	outputFileReference := outputFileName asFileReference.
	outputExportModuleFileReference := outputFileReference withExtension: 'smpmodule'.
	self validCurrentModule
		exportModulePublicInterfaceTo: outputExportModuleFileReference

]

{ #category : #writing }
MbndCompilationEnvironment >> writeLLVMAssemblyToFileNamed: outputFileName [
	^ self validCurrentModule writeLLVMAssemblyToFileNamed: outputFileName

]

{ #category : #writing }
MbndCompilationEnvironment >> writeMode: writeMode toFileNamed: outputFileName [
	^ self validCurrentModule writeMode: writeMode toFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeObjectLibToFileNamed: outputFileName [
	^ self validCurrentModule writeObjectLibToFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeObjectToFileNamed: outputFileName [
	^ self validCurrentModule writeObjectToFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeSharedToFileNamed: outputFileName [
	^ self validCurrentModule writeSharedToFileNamed: outputFileName
]
