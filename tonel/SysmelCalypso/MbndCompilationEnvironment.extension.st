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
		loadingEnvironment: true;
		yourself.
	environment backend: environmentBackend.
	environment announcer suspendAllWhile: [
		loadedModules do: [ :each |
			| modulePackage|
			modulePackage := environment ensurePackageNamed: each name asSymbol.
			each emitSmalltalkClassDeclarationsIntoRGEnvironment: environment package: modulePackage.
		].
		environment ensurePackageNamed: currentModule name asSymbol.
	].

	environment adoptForBrowser.
	environmentBackend loadingEnvironment: false.
	environment browse
]
