Class {
	#name : #MbndCompilationEnvironment,
	#superclass : #Object,
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
		'currentModuleStack'
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
MbndCompilationEnvironment class >> llvm_x86 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> llvm_x86_64 [
	^ self compilationTarget: MbndSlovimCompilationTarget llvm_x86_64
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment class >> spirv_vulkan [
	^ self compilationTarget: MbndSlovimCompilationTarget spirv_vulkan
]

{ #category : #parameters }
MbndCompilationEnvironment >> addLinkerArguments: arguments [
	<compileTime>
	self linkerArguments addAll: arguments
]

{ #category : #adding }
MbndCompilationEnvironment >> addLoadedModule: module [
	self loadedModules add: module.
	module name ifNotNil: [ :name | self loadedModuleDictionary at: name put: module ].
]

{ #category : #'semantic analysis' }
MbndCompilationEnvironment >> analyzeReferenceNode: referenceNode with: analyzer [
	^ (self asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: referenceNode;
		yourself
]

{ #category : #'module import' }
MbndCompilationEnvironment >> beginModule: moduleName [
	self pushCurrentModule.
	self validCurrentModule name: moduleName.
	self addLoadedModule: currentModule.
]

{ #category : #accessing }
MbndCompilationEnvironment >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndCompilationEnvironment >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #accessing }
MbndCompilationEnvironment >> coreModule [
	^ coreModule
]

{ #category : #accessing }
MbndCompilationEnvironment >> currentModule [
	^ currentModule
]

{ #category : #initialization }
MbndCompilationEnvironment >> defaultModuleTranslationMode [
	self object
]

{ #category : #'module translation mode' }
MbndCompilationEnvironment >> dll [
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
MbndCompilationEnvironment >> finishSemanticAnalysis [
	self validCurrentModule finishSemanticAnalysis
]

{ #category : #parameters }
MbndCompilationEnvironment >> freestanding [
	<compileTime>
	^ self
		noLibC;
		noRTTI.
]

{ #category : #testing }
MbndCompilationEnvironment >> hasConservativeGarbageCollector [
	^ self hasGarbageCollectionSupport and: [ self hasPreciseGarbageCollector not or: [ self hasGarbageCollectionStackMap not ] ]
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
MbndCompilationEnvironment >> hasObjectoTranslationMode [
	^ moduleTranslationMode = #object.
]

{ #category : #parameters }
MbndCompilationEnvironment >> hasPreciseGarbageCollector [
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
MbndCompilationEnvironment >> importModuleFrom: moduleExportFileName [
	| isCoreModule |
	isCoreModule := currentModule == coreModule.
	isCoreModule ifFalse: [ self pushCurrentModule ].
	
	self validCurrentModule importModuleFrom: moduleExportFileName.
	self addLoadedModule: currentModule.
	currentModule := nil.
	
	isCoreModule ifFalse: [ self popCurrentModule ].

]

{ #category : #'module import' }
MbndCompilationEnvironment >> importModuleNamed: moduleName [
	^ self loadedModuleDictionary at: moduleName ifAbsent: [
		self importOrCompileModuleNamed: moduleName.
	]
]

{ #category : #'module import' }
MbndCompilationEnvironment >> importOrCompileModuleNamed: moduleName [
	| importedModuleSourceLocations location resultModule |
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

	self validCurrentModule
		name: moduleName;
		sourceLocations: importedModuleSourceLocations asArray.
	self addLoadedModule: currentModule.
	resultModule := currentModule evaluateModuleLevelFilesIfExists: 'module.sysmel' asFileReference.
	"currentModule := nil."
	^ resultModule

]

{ #category : #initialization }
MbndCompilationEnvironment >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	moduleSourceLocations := OrderedCollection new.
	moduleSourceLocations add: MbndCoreAssets location / 'module-sources'.
	
	coreModule := MbndStandaloneModule for: self.
	currentModuleStack := OrderedCollection new.
	currentModule := coreModule.
	self defaultModuleTranslationMode.
]

{ #category : #accessing }
MbndCompilationEnvironment >> linkerArguments [
	^ linkerArguments ifNil: [ linkerArguments := OrderedCollection new ]
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
	self importModuleNamed: #'Sysmel.Core'
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModuleDictionary [
	^ loadedModuleDictionary ifNil: [ loadedModuleDictionary := Dictionary new ]
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModules [
	^ loadedModules ifNil: [ loadedModules := OrderedCollection new ]
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

{ #category : #'module translation mode' }
MbndCompilationEnvironment >> object [
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

{ #category : #'module import' }
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

{ #category : #'module import' }
MbndCompilationEnvironment >> pushCurrentModule [
	self hasMonolithicTranslationMode ifTrue: [ 
		currentModuleStack add: currentModule monolithicSubmoduleState.
		^ self
	].

	currentModuleStack add: currentModule.
	currentModule := nil.
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
			importedModules: loadedModules asArray copy;
			yourself
	].

	^ currentModule
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
	outputExportModuleFileReference := outputFileReference parent / (outputFileReference basenameWithoutExtension , '.smpmodule').
	self validCurrentModule exportModulePublicInterfaceTo: outputExportModuleFileReference


]

{ #category : #writing }
MbndCompilationEnvironment >> writeLLVMAssemblyToFileNamed: outputFileName [
	self validCurrentModule writeLLVMAssemblyToFileNamed: outputFileName.
	self writeExportModuleFor: outputFileName.

]

{ #category : #writing }
MbndCompilationEnvironment >> writeMode: writeMode toFileNamed: outputFileName [
	^ self validCurrentModule writeMode: writeMode toFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeObjectToFileNamed: outputFileName [
	^ self validCurrentModule writeObjectToFileNamed: outputFileName
]

{ #category : #writing }
MbndCompilationEnvironment >> writeSharedToFileNamed: outputFileName [
	^ self validCurrentModule writeSharedToFileNamed: outputFileName
]
