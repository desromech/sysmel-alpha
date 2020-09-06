Extension { #name : #MbndCompilationEnvironment }

{ #category : #'*SysmelCalypso' }
MbndCompilationEnvironment >> browseModuleNamedWithCalypso: moduleName [
	self compileModuleNamed: moduleName.
	self browseWithCalypso
]

{ #category : #'*SysmelCalypso' }
MbndCompilationEnvironment >> browseWithCalypso [
	| environmentBackend environment |
	self assert: currentModule isNotNil.
	
	environment := RGEnvironment new.
	environmentBackend := (MbndRGEnvironmentBackend for: environment)
		compilationEnvironment: self;
		targetModule: currentModule;
		targetDirectory: currentModule sourceLocations last asFileReference;
		loadingEnvironment: true;
		yourself.
	environment backend: environmentBackend.
	environment announcer suspendAllWhile: [
		loadedModules reject: [:e | e == currentModule] thenDo: [ :each |
			| modulePackage|
			modulePackage := environment ensurePackageNamed: ('[Import]' , each name) asSymbol.
			each emitSmalltalkClassDeclarationsIntoRGEnvironment: environment package: modulePackage.
		].
		currentModule addSmalltalkPackagesFromFileSystemIntoRGEnvironment: environment
	].

	environment adoptForBrowser.
	environmentBackend loadingEnvironment: false.
	environment browse
]
