Class {
	#name : #MbndCompilationEnvironment,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'compilationTarget',
		'coreModule',
		'useLibC',
		'hasRuntimeTypeInformation',
		'hasStandardLibrary',
		'hasGarbageCollectionSupport',
		'hasGarbageCollectionStackMap',
		'hasLibC',
		'optimizationLevel',
		'hasGPUSupport',
		'hasExceptions',
		'linkerArguments',
		'currentModule',
		'loadedModuleDictionary',
		'loadedModules',
		'moduleSourceLocations',
		'moduleTranslationMode',
		'currentModuleStack',
		'outputDirectory',
		'outputMode',
		'hasBeginModule',
		'importedModuleModificationTimeCache',
		'validatedDependencyModules'
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
MbndCompilationEnvironment class >> spirv_vulkan [
	^ self compilationTarget: MbndSlovimCompilationTarget spirv_vulkan
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
	moduleSourceLocations add: location asFileReference
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

{ #category : #accessing }
MbndCompilationEnvironment >> compilationTarget [
	^ compilationTarget
]

{ #category : #'module import' }
MbndCompilationEnvironment >> compileModuleNamed: moduleName [
	| importedModuleSourceLocations location resultModule isCoreModule |
	importedModuleSourceLocations := OrderedCollection new.
	moduleSourceLocations do: [ :each | 
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
	
	testFileRef := outputDirectory resolve: fileRef.
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

{ #category : #'module import' }
MbndCompilationEnvironment >> evaluateFileNamed: fileName [
	^ self validCurrentModule evaluateFileNamed: fileName
]

{ #category : #'module import' }
MbndCompilationEnvironment >> evaluateFileNamedOnce: fileName [
	hasBeginModule ifFalse: [
		self beginModule: fileName asFileReference basenameWithoutExtension asSymbol
	].

	^ self validCurrentModule evaluateFileNamedOnce: fileName
]

{ #category : #'module import' }
MbndCompilationEnvironment >> evaluateLanguage: languageName source: sourceString [
	^ self validCurrentModule evaluateLanguage: languageName source: sourceString
]

{ #category : #'as yet unclassified' }
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

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleFileReferenceFor: moduleName [
	^ self validOutputDirectory / (moduleName , '.smpmodule')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findImportModuleLFlagsFileReferenceFor: moduleName [
	^ self validOutputDirectory / (moduleName , '.smpmodule.lflags')
]

{ #category : #'module import' }
MbndCompilationEnvironment >> findModuleObjectFileReferenceFor: moduleName [
	^ self validOutputDirectory / (moduleName , self importedModuleExtension)
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> finishAndEmitModule [
	| outputFileName outputFileReference result outputShaderFileName |
	currentModule ifNil: [ ^ self ].
	self finishSemanticAnalysis.
	
	outputFileName := self validCurrentModule name , (compilationTarget extensionForModuleOutputMode: outputMode).
	outputShaderFileName := self validCurrentModule name , (compilationTarget extensionForEmbeddedShaderCopy).

	outputFileReference := self validOutputDirectory / outputFileName.
	result := self validCurrentModule
		embeddedShaderCopyOutputFile: self validOutputDirectory / outputShaderFileName;
		writeMode: outputMode toFileNamed:  outputFileReference.
	self writeExportModuleFor: outputFileReference.
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
	^ hasExceptions ifNil: [ hasExceptions := true ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasExceptions: aBoolean [
	<compileTime>
	hasExceptions := aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGPUSupport [
	<compileTime>
	^ hasGPUSupport ifNil: [ hasGPUSupport := true ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectedRuntime [
	<compileTime>
	^ self hasRuntimeTypeInformation and: [self hasGarbageCollectionSupport]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionStackMap [
	<compileTime>
	^ hasGarbageCollectionStackMap ifNil: [ hasGarbageCollectionStackMap := false ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionStackMap: aBoolean [
	<compileTime>
	hasGarbageCollectionStackMap := aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionSupport [
	<compileTime>
	^ hasGarbageCollectionSupport ifNil: [ hasGarbageCollectionSupport := self hasRuntimeTypeInformation ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasGarbageCollectionSupport: aBoolean [
	<compileTime>
	hasGarbageCollectionSupport := aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasLibC [
	<compileTime>
	^ hasLibC ifNil: [ hasLibC := self compilationTarget isGPU not ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasLibC: aBoolean [
	<compileTime>
	hasLibC := aBoolean
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
	^ true
]

{ #category : #testing }
MbndCompilationEnvironment >> hasReferenceCountingCollector [
	<compileTime>
	^ false
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasRuntimeTypeInformation [
	<compileTime>
	^ hasRuntimeTypeInformation ifNil: [ hasRuntimeTypeInformation := self compilationTarget isGPU not ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasRuntimeTypeInformation: aBoolean [
	<compileTime>
	hasRuntimeTypeInformation := aBoolean
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasStandardLibrary [
	<compileTime>
	^ hasStandardLibrary ifNil: [ hasStandardLibrary := true ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasStandardLibrary: aBoolean [
	<compileTime>
	hasStandardLibrary := aBoolean
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

	importModuleFileReference := self validateDependencyModuleIsUpdated: moduleName.	
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
	moduleSourceLocations := OrderedCollection new.
	moduleSourceLocations add: MbndCoreAssets location / 'module-sources'.
	importedModuleModificationTimeCache := Dictionary new.
	outputMode := #executable.
	hasBeginModule := false.

	"Optional dependency."
	[
		moduleSourceLocations add: MbndAbstractGPUAssets location / 'bindings' / 'sysmel'
	]on: Error do: [:e |
	].
	
	coreModule := MbndStandaloneModule for: self.
	currentModuleStack := OrderedCollection new.
	currentModule := coreModule.
	self defaultModuleTranslationMode.
]

{ #category : #initialization }
MbndCompilationEnvironment >> initializeWithSanitizedCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	moduleSourceLocations := OrderedCollection new.
	moduleSourceLocations add: MbndCoreAssets location / 'module-sources'.
	importedModuleModificationTimeCache := Dictionary new.
	outputMode := #executable.
	hasBeginModule := false.

	"Optional dependency."
	[
		moduleSourceLocations add: MbndAbstractGPUAssets location / 'bindings' / 'sysmel'
	]on: Error do: [:e |
	].
	
	coreModule := MbndStandaloneModule for: self.
	currentModuleStack := OrderedCollection new.
	currentModule := coreModule.
	self defaultModuleTranslationMode.
]

{ #category : #'module output format' }
MbndCompilationEnvironment >> llvmAssembly [
	self outputMode: #llvm_assembly
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
MbndCompilationEnvironment >> moduleSourceLocations: theSourceLocations [
	moduleSourceLocations := theSourceLocations.
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
	| result |
	result := self class compilationTarget: compilationTarget asCleanCompilationTarget.
	result
		validatedDependencyModules: self validatedDependencyModules;
		hasRuntimeTypeInformation: self hasRuntimeTypeInformation;
		hasExceptions: self hasExceptions;
		hasStandardLibrary: self hasStandardLibrary;
		hasGarbageCollectionSupport: self hasGarbageCollectionSupport;
		hasGarbageCollectionStackMap: self hasGarbageCollectionStackMap;
		hasLibC: self hasLibC;
		useLibC: self useLibC;
		optimizationLevel: self optimizationLevel;
		moduleTranslationMode: moduleTranslationMode;
		outputMode: self outputModeForDependencies;
		outputDirectory: outputDirectory;
		moduleSourceLocations: moduleSourceLocations copy.

	^ result.
]

{ #category : #parameters }
MbndCompilationEnvironment >> noExceptions [
	<compileTime>
	self hasExceptions: false
]

{ #category : #parameters }
MbndCompilationEnvironment >> noGC [
	<compileTime>
	self hasGarbageCollectionSupport: false
]

{ #category : #parameters }
MbndCompilationEnvironment >> noLibC [
	<compileTime>
	self
		hasLibC: false;
		useLibC: false
]

{ #category : #parameters }
MbndCompilationEnvironment >> noRTTI [
	<compileTime>
	self hasRuntimeTypeInformation: false
]

{ #category : #parameters }
MbndCompilationEnvironment >> noStandardLibrary [
	<compileTime>
	self hasStandardLibrary: false
]

{ #category : #initialization }
MbndCompilationEnvironment >> noStandardModuleSourceLocations [
	moduleSourceLocations removeAll
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
	^ optimizationLevel ifNil: [ optimizationLevel := 0 ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> optimizationLevel: anInteger [
	^ optimizationLevel := anInteger
]

{ #category : #initialization }
MbndCompilationEnvironment >> outputDirectory: anOutputDirectory [
	outputDirectory := anOutputDirectory asFileReference asAbsolute canonicalize.
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

{ #category : #'module output format' }
MbndCompilationEnvironment >> shared [
	self outputMode: #shared
]

{ #category : #'module import' }
MbndCompilationEnvironment >> shouldCompileModule: moduleName withFileReference: importModuleFileReference [
	importModuleFileReference exists ifFalse: [ ^ true ].
	
	^ (self getLastModificationTimeOfModule: moduleName) > importModuleFileReference modificationTime.

]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> useExplicitSJLJ [
	compilationTarget setNoExceptionModel
]

{ #category : #parameters }
MbndCompilationEnvironment >> useLibC [
	<compileTime>
	^ useLibC ifNil: [ useLibC := self hasLibC ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> useLibC: aBoolean [
	<compileTime>
	useLibC := aBoolean
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

{ #category : #initialization }
MbndCompilationEnvironment >> validOutputDirectory [
	outputDirectory ifNil: [ outputDirectory := (FileSystem workingDirectory / 'sysmel-out-dir') asAbsolute  canonicalize ].
	outputDirectory ensureCreateDirectory.

	(outputDirectory exists and: [ outputDirectory isDirectory ]) ifFalse: [ 
		self error: 'Output directory "{1}" could not be created.' format: { outputDirectory fullName }
	].

	^ outputDirectory
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validateDependencyModuleIsUpdated: moduleName [
	| importModuleFileReference result |
	result := self validatedDependencyModules at: moduleName ifAbsent: [nil].
	result == #pending ifTrue: [ self error: 'Cylic dependencies for module ' , moduleName ].
	result ifNotNil: [ ^ result ].

	self validatedDependencyModules at: moduleName put: nil.
	
	importModuleFileReference := self findImportModuleFileReferenceFor: moduleName.
	(self shouldCompileModule: moduleName withFileReference: importModuleFileReference) ifTrue: [
		| moduleCompilationEnvironment |
		moduleCompilationEnvironment := self newCompilationEnvironmentForCleanModuleBuilding.
		moduleName ~= self coreModuleName ifTrue: [ 
			moduleCompilationEnvironment loadRuntimeCoreLibrary
		].
			
		moduleCompilationEnvironment
			compileModuleNamed: moduleName;
			finishAndEmitModule.
		importedModuleModificationTimeCache at: moduleName put: importModuleFileReference modificationTime.
	].

	result := importModuleFileReference.
	self validatedDependencyModules at: moduleName put: result.
	^ result
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validateIndirectModuleIsUpdated: moduleName [
	^ self validateDependencyModuleIsUpdated: moduleName
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validatedDependencyModules [
	^ validatedDependencyModules ifNil: [ validatedDependencyModules := Dictionary new ]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> validatedDependencyModules: sharedDependencies [
	^ validatedDependencyModules := sharedDependencies
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
	| outputFileReference outputExportModuleFileReference outputExportDepsFileReference outputExportLinkerFlags |
	outputFileReference := outputFileName asFileReference.
	outputExportModuleFileReference := outputFileReference withExtension: 'smpmodule'.
	outputExportDepsFileReference := outputExportModuleFileReference withExtension: 'smpmodule.deps'.
	outputExportLinkerFlags := outputExportModuleFileReference withExtension: 'smpmodule.lflags'.
	self validCurrentModule
		exportModulePublicInterfaceTo: outputExportModuleFileReference;
		exportModuleDependenciesTo: outputExportDepsFileReference;
		exportExportLinkerFlagsTo: outputExportLinkerFlags

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
