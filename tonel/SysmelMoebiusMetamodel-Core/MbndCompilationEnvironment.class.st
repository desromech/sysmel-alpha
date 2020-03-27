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
		'loadedModules'
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

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> beginModule: moduleName [
	currentModule := nil.
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

{ #category : #'module construction' }
MbndCompilationEnvironment >> evaluateFileNamed: fileName [
	^ self validCurrentModule evaluateFileNamed: fileName
]

{ #category : #'module construction' }
MbndCompilationEnvironment >> evaluateFileNamedOnce: fileName [
	^ self validCurrentModule evaluateFileNamedOnce: fileName
]

{ #category : #'module construction' }
MbndCompilationEnvironment >> evaluateLanguage: languageName source: sourceString [
	^ self validCurrentModule evaluateLanguage: languageName source: sourceString
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> evaluateRuntimeCoreLibrary [
	coreModule loadRuntimeCoreLibrary
]

{ #category : #'module construction' }
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

{ #category : #serialization }
MbndCompilationEnvironment >> importModuleFrom: moduleExportFileName [
	currentModule == coreModule ifFalse: [ currentModule := nil ].
	self validCurrentModule importModuleFrom: moduleExportFileName.
	self addLoadedModule: currentModule.
	currentModule := nil
]

{ #category : #adding }
MbndCompilationEnvironment >> importModuleNamed: moduleName [
	^ self loadedModuleDictionary at: moduleName ifAbsent: [
		self error: 'Automatic module importation mechanism is not yet implemented.'
	]
]

{ #category : #initialization }
MbndCompilationEnvironment >> initializeWithCompilationTarget: aCompilationTarget [
	compilationTarget := aCompilationTarget.
	coreModule := MbndStandaloneModule for: self.
	currentModule := coreModule.
]

{ #category : #accessing }
MbndCompilationEnvironment >> linkerArguments [
	^ linkerArguments ifNil: [ linkerArguments := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironment >> loadRuntimeCoreLibrary [
	self flag: 'TODO: support importing this runtime core library.'.
	coreModule
		name: #SysmelCore;
		loadRuntimeCoreLibrary
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModuleDictionary [
	^ loadedModuleDictionary ifNil: [ loadedModuleDictionary := Dictionary new ]
]

{ #category : #accessing }
MbndCompilationEnvironment >> loadedModules [
	^ loadedModules ifNil: [ loadedModules := OrderedCollection new ]
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

{ #category : #parameters }
MbndCompilationEnvironment >> optimizationLevel [
	^ optimizationLevel ifNil: [ optimizationLevel := 0 ]
]

{ #category : #parameters }
MbndCompilationEnvironment >> optimizationLevel: anInteger [
	^ optimizationLevel := anInteger
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

{ #category : #'module construction' }
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
