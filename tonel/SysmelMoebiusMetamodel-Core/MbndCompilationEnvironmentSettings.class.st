Class {
	#name : #MbndCompilationEnvironmentSettings,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'useLibC',
		'hasRuntimeTypeInformation',
		'hasStandardLibrary',
		'hasGarbageCollectionSupport',
		'hasGarbageCollectionStackMap',
		'hasLibC',
		'optimizationLevel',
		'hasGPUSupport',
		'hasExceptions',
		'moduleSourceLocations',
		'thirdPartyLibrarySpecLocations',
		'wbtPlatform',
		'wbtEnvironment',
		'compilationTarget',
		'enableDebugInformation'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #adding }
MbndCompilationEnvironmentSettings >> addModuleSourceLocation: location [
	moduleSourceLocations add: location asFileReference
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> buildDirectory: aDirectory [
	self wbtEnvironment buildDirectory: aDirectory
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> compilationTarget [
	^ compilationTarget ifNil: [
		compilationTarget := MbndSlovimCompilationTarget forWBTPlatform: wbtPlatform.
		self enableDebugInformation ifTrue: [ compilationTarget withDebugInformation ].
		compilationTarget
	]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> enableDebugInformation [
	^ enableDebugInformation ifNil: [ enableDebugInformation := false ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> enableDebugInformation: aBoolean [
	enableDebugInformation := aBoolean
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasExceptions [
	^ hasExceptions ifNil: [ hasExceptions := true ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasExceptions: anObject [
	hasExceptions := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGPUSupport [
	^ hasGPUSupport ifNil: [ hasGPUSupport := true ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGPUSupport: anObject [
	hasGPUSupport := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGarbageCollectionStackMap [
	^ hasGarbageCollectionStackMap ifNil: [ hasGarbageCollectionStackMap := false ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGarbageCollectionStackMap: anObject [
	hasGarbageCollectionStackMap := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGarbageCollectionSupport [
	^ hasGarbageCollectionSupport ifNil: [ hasGarbageCollectionSupport := self hasRuntimeTypeInformation ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasGarbageCollectionSupport: anObject [
	hasGarbageCollectionSupport := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasLibC [
	^ hasLibC ifNil: [ hasLibC := self compilationTarget isGPU not ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasLibC: anObject [
	hasLibC := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasRuntimeTypeInformation [
	^ hasRuntimeTypeInformation ifNil: [ hasRuntimeTypeInformation := self compilationTarget isGPU not ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasRuntimeTypeInformation: anObject [
	hasRuntimeTypeInformation := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasStandardLibrary [
	^ hasStandardLibrary ifNil: [ hasStandardLibrary := true ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> hasStandardLibrary: anObject [
	hasStandardLibrary := anObject
]

{ #category : #initialization }
MbndCompilationEnvironmentSettings >> initialize [
	| addedLocations |
	super initialize.
	moduleSourceLocations := OrderedCollection new.
	thirdPartyLibrarySpecLocations := OrderedCollection new.

	addedLocations := Set new.	
	(MbndIcebergProjectAssets allSubclasses , {MbndAbstractGPUBindings}) do: [ : each |
		| location |
		location := each location.
		(location exists and: [ (addedLocations includes: location) not ]) ifTrue: [ 
			moduleSourceLocations add: location / 'module-sources'.
			thirdPartyLibrarySpecLocations add: location / 'native-module-sources'.
			addedLocations add: location
		].
	].
	
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> moduleSourceLocations [
	^ moduleSourceLocations
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> moduleSourceLocations: theLocations [
	moduleSourceLocations := theLocations
]

{ #category : #parameters }
MbndCompilationEnvironmentSettings >> noExceptions [
	<compileTime>
	self hasExceptions: false
]

{ #category : #parameters }
MbndCompilationEnvironmentSettings >> noGC [
	<compileTime>
	self hasGarbageCollectionSupport: false
]

{ #category : #parameters }
MbndCompilationEnvironmentSettings >> noLibC [
	<compileTime>
	self
		hasLibC: false;
		useLibC: false
]

{ #category : #parameters }
MbndCompilationEnvironmentSettings >> noRTTI [
	<compileTime>
	self hasRuntimeTypeInformation: false
]

{ #category : #parameters }
MbndCompilationEnvironmentSettings >> noStandardLibrary [
	<compileTime>
	self hasStandardLibrary: false
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> optimizationLevel [
	^ optimizationLevel ifNil: [ optimizationLevel := 0 ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> optimizationLevel: anObject [
	optimizationLevel := anObject
]

{ #category : #copying }
MbndCompilationEnvironmentSettings >> postCopy [
	moduleSourceLocations := moduleSourceLocations copy.
	thirdPartyLibrarySpecLocations := thirdPartyLibrarySpecLocations copy.
]

{ #category : #'as yet unclassified' }
MbndCompilationEnvironmentSettings >> setupForWBTPlatform: aWbtPlatform [
	self
		wbtPlatform: aWbtPlatform;
		wbtEnvironment: aWbtPlatform environment;
		enableDebugInformation: aWbtPlatform environment hasBuildModeWithDebugInformation.
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> thirdPartyLibrarySpecLocations [
	^ thirdPartyLibrarySpecLocations
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> thirdPartyLibrarySpecLocations: theLocations [
	thirdPartyLibrarySpecLocations := theLocations
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> useLibC [
	^ useLibC ifNil: [ hasStandardLibrary := true ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> useLibC: anObject [
	useLibC := anObject
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> wbtEnvironment [
	^ wbtEnvironment ifNil: [ wbtEnvironment := (WBTBuildEnvironment forHostPlatform: self compilationTarget wbtPlatform)
		addPackageSpecLocations: thirdPartyLibrarySpecLocations;
		yourself
	]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> wbtEnvironment: anObject [
	wbtEnvironment := anObject.
	wbtEnvironment addPackageSpecLocations: thirdPartyLibrarySpecLocations.
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> wbtPlatform [
	^ wbtPlatform ifNil: [ wbtPlatform := wbtEnvironment platform ]
]

{ #category : #accessing }
MbndCompilationEnvironmentSettings >> wbtPlatform: anObject [
	wbtPlatform := anObject
]
