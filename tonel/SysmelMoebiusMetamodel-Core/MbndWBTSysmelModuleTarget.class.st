Class {
	#name : #MbndWBTSysmelModuleTarget,
	#superclass : #WBTModuleSourceTarget,
	#instVars : [
		'wbtModule',
		'sources',
		'buildTargetDependencies',
		'sysmelModuleName',
		'semanticAnalyzedCompilationEnvironment',
		'isNamedSysmelModule',
		'isRuntimeCoreLibrary',
		'implicitFileDependencies',
		'importedModules',
		'importedIndirectModules',
		'thirdPartyPackageDependencies',
		'importModuleFileReference',
		'relativeFileReference',
		'objectFileReference',
		'linkerArguments',
		'depsCacheFileReference'
	],
	#category : #'SysmelMoebiusMetamodel-Core-WBT'
}

{ #category : #adding }
MbndWBTSysmelModuleTarget >> addIntermediateObjectFilesToModule: targetModule [
	WBTLLVMLanguage uniqueInstance createIntermediateObjectFilesFor: self module: targetModule
]

{ #category : #adding }
MbndWBTSysmelModuleTarget >> addSourceFile: sourceFile [
	sources add: sourceFile.
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> asFileReference [
	^ self objectFileReference
]

{ #category : #converting }
MbndWBTSysmelModuleTarget >> asWBTVarSubstitution [
	^ self objectFileReference asWBTVarSubstitution
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> buildTargetDependencies [
	^ buildTargetDependencies ifNil: [ buildTargetDependencies := self computeBuildTargetDependencies ]
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> computeBuildTargetDependencies [
	| linkLibraries |
	self fetchDependenciesFromCache ifFalse: [
		self fetchDependenciesFromSemanticAnalysis ifFalse: [ ^ sources ]
	].

	self ensureBuildAction.
	linkLibraries := importedModules , importedIndirectModules,
		thirdPartyPackageDependencies.
	wbtModule
		addIndirectLinkLibraries: linkLibraries;
		addIndirectLinkerArguments: linkerArguments.
	^ sources , implicitFileDependencies , linkLibraries
		
]

{ #category : #hook }
MbndWBTSysmelModuleTarget >> computeIndirectExtraDependenciesForModuleTarget [
	self buildTargetDependencies
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> computeSysmelModuleName [
	| packageName wbtModuleName |
	packageName := package name.
	wbtModuleName := wbtModule name.
	(packageName = wbtModuleName or: [ package isRootPackage ]) ifTrue: [ ^ wbtModuleName ].
	^ (packageName , '-' , wbtModuleName) asSymbol
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> coreModuleName [
	^ MbndCompilationEnvironment coreModuleName
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> depsCacheFileReference [
	^ depsCacheFileReference ifNil: [depsCacheFileReference := self buildEnvironment validBuildSysmelCacheDirectory / (self sysmelModuleName , '.deps') ].
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> ensureBuildAction [
	self buildActions ifNotEmpty: [ ^ self ].
	self addBuildAction: MbndWBTSysmelModuleCompilationBuildAction new.
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> fetchDependenciesFromCache [
	self depsCacheFileReference exists ifFalse: [ ^ false ].
	self parseDepsCacheFile.
	
	buildTargetDependencies := sources , implicitFileDependencies , importedModules , importedIndirectModules,
		thirdPartyPackageDependencies.
	self isSatisfiedBuildTarget ifTrue: [ ^ true ].
	buildTargetDependencies := nil.
	self invalidateTimestamps.
	^ false
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> fetchDependenciesFromSemanticAnalysis [
	| sysmelModule explicitFileDependencies |
	(sources allSatisfy: [ :each | each exists ]) ifFalse: [ ^ false ].
	self semanticAnalyzedCompilationEnvironment.

	sysmelModule := semanticAnalyzedCompilationEnvironment currentModule.
	explicitFileDependencies := sources collect: [ :each | each fileReference ] as: Set.
	implicitFileDependencies := (sysmelModule evaluatedFileSet difference: explicitFileDependencies) asArray sorted
		collect: [:each | self buildEnvironment makeImplicitSourceFileDependencyFor: each ].

	importedModules := sysmelModule importedModules collect: [:each | self buildEnvironment getOrLoadSysmelModulePackage: each name].
	importedIndirectModules := sysmelModule importedIndirectModules collect: [:each | self buildEnvironment getOrLoadSysmelModulePackage: each].
	thirdPartyPackageDependencies := sysmelModule thirdPartyLibraryDependencies collect: [ :each | self buildEnvironment getOrLoadPackageNamed: each].
	linkerArguments := sysmelModule linkerArguments.
	^ true
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> importModuleFileReference [
	^ importModuleFileReference ifNil: [ importModuleFileReference := self buildEnvironment validBuildSysmelCacheDirectory / (self sysmelModuleName , '.smpmodule') ]
]

{ #category : #initialization }
MbndWBTSysmelModuleTarget >> initialize [
	super initialize.
	sources := OrderedCollection new.
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> isNamedSysmelModule [
	^ isNamedSysmelModule ifNil: [ isNamedSysmelModule := false ]
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> isNamedSysmelModule: anObject [
	isNamedSysmelModule := anObject
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> isRuntimeCoreLibrary [
	^ isRuntimeCoreLibrary ifNil: [ isRuntimeCoreLibrary := self sysmelModuleName = self coreModuleName ]
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> isRuntimeCoreLibrary: anObject [
	isRuntimeCoreLibrary := anObject
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> makeCompilationEnvironment [
	^ (MbndCompilationEnvironment withSettings: self platform sysmelSettings copy)
		objectPerModule;
		llvmAssembly
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> makeCompilationEnvironmentWithSemanticAnalysis [
	| compilationEnvironment |
	compilationEnvironment := self makeCompilationEnvironment.
	self isRuntimeCoreLibrary ifFalse: [ 
		compilationEnvironment loadRuntimeCoreLibrary.
	].
	self isNamedSysmelModule ifTrue: [ 
		compilationEnvironment compileModuleNamed: self sysmelModuleName.
	] ifFalse: [ 
		compilationEnvironment beginModule: self sysmelModuleName.
		sources do: [ :each |
			compilationEnvironment evaluateFileNamedOnce: each asWBTVarSubstitution
		].
	].
	compilationEnvironment finishSemanticAnalysis.
	^ compilationEnvironment
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> objectFileReference [
	^ objectFileReference ifNil: [objectFileReference := package validBuildObjectDirectory resolve: self relativeFileReference]
]

{ #category : #'as yet unclassified' }
MbndWBTSysmelModuleTarget >> parseDepsCacheFile [
	| json |
	self depsCacheFileReference exists ifFalse: [ ^ false ].
	
	json := NeoJSONReader fromString: self depsCacheFileReference contents.
	implicitFileDependencies := (json at: 'files') collect: [ :each | self buildEnvironment makeImplicitSourceFileDependencyFor: each].
	importedModules := (json at: 'importedModules') collect: [ :each | self buildEnvironment getOrLoadSysmelModulePackage: each].
	importedIndirectModules := (json at: 'importedIndirectModules') collect: [ :each | self buildEnvironment getOrLoadSysmelModulePackage: each].
	thirdPartyPackageDependencies := (json at: 'thirdPartyPackageDependencies') collect: [ :each | self buildEnvironment getOrLoadPackageNamed: each].
	linkerArguments := json at: 'linkerArguments'

]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> relativeFileReference [
	^ relativeFileReference ifNil: [relativeFileReference := (self sysmelModuleName , '.ll') asFileReference]
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> semanticAnalyzedCompilationEnvironment [
	^ semanticAnalyzedCompilationEnvironment ifNil: [ semanticAnalyzedCompilationEnvironment := self makeCompilationEnvironmentWithSemanticAnalysis
	]
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> sysmelModuleName [
	^ sysmelModuleName ifNil: [ sysmelModuleName := self computeSysmelModuleName ]
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> sysmelModuleName: anObject [
	sysmelModuleName := anObject
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> targetOutputFileReferences [
	^ { self objectFileReference . self importModuleFileReference . self depsCacheFileReference}
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> wbtModule [
	^ wbtModule
]

{ #category : #accessing }
MbndWBTSysmelModuleTarget >> wbtModule: anObject [
	wbtModule := anObject
]

{ #category : #writing }
MbndWBTSysmelModuleTarget >> writeDepsToCache [
	| depsData |
	depsData := Dictionary newFromPairs: {
		#files . (implicitFileDependencies collect: [:each | each asWBTVarSubstitution ]).
		#importedModules . (importedModules collect: [:each | each name ]).
		#importedIndirectModules . (importedIndirectModules collect: [:each | each name ]).
		#thirdPartyPackageDependencies . (thirdPartyPackageDependencies collect: [:each | each name]).
		#linkerArguments . (linkerArguments collect: [:each | each asWBTVarSubstitution])
	}.
	self depsCacheFileReference parent ensureCreateDirectory.
	self depsCacheFileReference writeStreamDo: [ :out |
		out truncate; nextPutAll: (NeoJSONWriter toStringPretty: depsData)
	].
]
