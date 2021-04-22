Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace',
		'evaluatedFileSet',
		'pendingDelayedSemanticAnalysisSet',
		'extensionMacros',
		'extensionOverloadedMethods',
		'languageInterfaceCache',
		'moduleLevelInlineAssembly',
		'embeddedShaderCopyOutputFile',
		'externalTemplateInstances',
		'anonSymbolCount',
		'extensionMethods',
		'specialStructures',
		'entitiesWithPendingDefinitionFragments',
		'addedGCClasses',
		'addedClasses',
		'mainSourceFileName'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
TMbndModule >> accept: aVisitor [
	^ aVisitor visitModule: self
]

{ #category : #accessing }
TMbndModule >> activePackageName [
	^ nil
]

{ #category : #adding }
TMbndModule >> addModuleLevelInlineAssembly: node [
	self moduleLevelInlineAssembly add: node
]

{ #category : #accessing }
TMbndModule >> addedClasses [
	^ addedClasses ifNil: [ addedClasses := OrderedCollection new ]
]

{ #category : #accessing }
TMbndModule >> addedGCClasses [
	^ addedGCClasses ifNil: [ addedGCClasses := OrderedCollection new ]
]

{ #category : #accessing }
TMbndModule >> allExtensionsDo: aBlock [
	self extensionMacros do: [ :each | aBlock value: each last ].
	self extensionOverloadedMethods do: [ :each | aBlock value: each last ].
	self externalTemplateInstances do: [ :each | aBlock value: each second ].

]

{ #category : #evaluation }
TMbndModule >> analyzeAndEvaluateAST: ast [
	| parsedSource |
	parsedSource := MbndLanguageParsedSource new
		ast: ast;
		language: MbndGenericMacroLanguageInterface new.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #evaluation }
TMbndModule >> analyzeAndEvaluateAST: ast inScope: scope [
	| analyzerAndEvaluator |
	analyzerAndEvaluator := MbndAstSemanticAnalyzerAndEvaluator new
		module: self;
		scope: scope.
	^ MbndProfiler component: #analysisAndEvaluation with: [analyzerAndEvaluator analyzeAndEvaluateFunctionContent: ast]

]

{ #category : #evaluation }
TMbndModule >> analyzeAndEvaluateParsedSource: parsedSource [
	^ self analyzeAndEvaluateParsedSource: parsedSource withWorkingDirectory: nil
]

{ #category : #evaluation }
TMbndModule >> analyzeAndEvaluateParsedSource: parsedSource withWorkingDirectory: workingDirectory [
	^ self analyzeAndEvaluateAST: parsedSource ast inScope: (self newSourceEvaluationScopeForLanguage: parsedSource language withWorkingDirectory: workingDirectory)
]

{ #category : #'semantic analysis' }
TMbndModule >> analyzeReferenceNode: referenceNode with: analyzer [
	^ (self asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: referenceNode;
		yourself
]

{ #category : #extensions }
TMbndModule >> applyExtensionMacros [
	self extensionMacros do: [ :each |
		| parentEntity selector macro |
		parentEntity := each first.
		selector := each second.
		macro := each third.
	
		parentEntity macroMethodDict at: selector put: macro.
	]
]

{ #category : #extensions }
TMbndModule >> applyExtensionOverloadedMethods [
	self extensionOverloadedMethods do: [ :each |
		| parentEntity method |
		parentEntity := each first.
		method := each third.
		
		parentEntity
			addChild: method;
			addImportedOverloadedMethodNoCheck: method
	]
]

{ #category : #'as yet unclassified' }
TMbndModule >> children [
	^ { self globalNamespace }
]

{ #category : #'as yet unclassified' }
TMbndModule >> compilationTarget [
	self explicitRequirement
]

{ #category : #accessing }
TMbndModule >> embeddedShaderCopyOutputFile [
	^ embeddedShaderCopyOutputFile
]

{ #category : #accessing }
TMbndModule >> embeddedShaderCopyOutputFile: aFileName [
	embeddedShaderCopyOutputFile := aFileName 
]

{ #category : #'semantic analysis' }
TMbndModule >> enqueueDelayedSemanticAnalysis [
]

{ #category : #'semantic analysis' }
TMbndModule >> enqueueProgramEntityWithDelayedSemanticAnalysis: programEntity [
	self pendingDelayedSemanticAnalysisSet add: programEntity
]

{ #category : #'semantic analysis' }
TMbndModule >> entitiesWithPendingDefinitionFragments [
	^ entitiesWithPendingDefinitionFragments ifNil: [ entitiesWithPendingDefinitionFragments := OrderedCollection new ]
]

{ #category : #'semantic analysis' }
TMbndModule >> evaluateAllPendingDefinitionFragments [
	| toEvaluate |
	entitiesWithPendingDefinitionFragments ifNil: [ ^ self ].
	toEvaluate := entitiesWithPendingDefinitionFragments asArray.
	entitiesWithPendingDefinitionFragments removeAll.
	toEvaluate do: [ :each | each evaluateAllPendingDefinitionFragments ]
]

{ #category : #evaluation }
TMbndModule >> evaluateFileNamed: fileName [
	| parsedSource fileReference |
	fileReference := fileName asFileReference.
	parsedSource := self parseFileNamed: fileReference.
	^ self analyzeAndEvaluateParsedSource: parsedSource	withWorkingDirectory: fileReference parent
]

{ #category : #evaluation }
TMbndModule >> evaluateFileNamedOnce: fileName [
	| fileReference parsedSource |
	fileReference := fileName asFileReference asAbsolute canonicalize.
	(self evaluatedFileSet includes: fileReference) ifTrue: [ ^ self ].
	mainSourceFileName ifNil: [
		mainSourceFileName := fileReference fullName
	].
	
	self evaluatedFileSet add: fileReference.
	parsedSource := self parseFileNamed: fileReference.
	self analyzeAndEvaluateParsedSource: parsedSource	 withWorkingDirectory: fileReference parent
]

{ #category : #evaluation }
TMbndModule >> evaluateLanguage: languageName source: sourceString [
	| parsedSource |
	parsedSource := self parseLanguage: languageName source: sourceString.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #evaluation }
TMbndModule >> evaluatedFileSet [
	^ evaluatedFileSet ifNil: [ evaluatedFileSet := Set new ]
]

{ #category : #accessing }
TMbndModule >> extensionMacros [
	^ extensionMacros ifNil: [ extensionMacros := OrderedCollection new ]
]

{ #category : #accessing }
TMbndModule >> extensionMethods [
	^ extensionMethods ifNil: [ extensionMethods := OrderedCollection new ]
]

{ #category : #accessing }
TMbndModule >> extensionOverloadedMethods [
	^ extensionOverloadedMethods ifNil: [ extensionOverloadedMethods := OrderedCollection new ]
]

{ #category : #accessing }
TMbndModule >> externalTemplateInstances [
	^ externalTemplateInstances ifNil: [ externalTemplateInstances := OrderedCollection new ]
]

{ #category : #'semantic analysis' }
TMbndModule >> finishSemanticAnalysis [
	| toAnalyze |
	[ self pendingDelayedSemanticAnalysisSet isNotEmpty ] whileTrue: [
		toAnalyze := self pendingDelayedSemanticAnalysisSet asArray.
		self pendingDelayedSemanticAnalysisSet removeAll.
		toAnalyze do: [:each | each ensureSemanticAnalysis ].
		self evaluateAllPendingDefinitionFragments
	]
]

{ #category : #'as yet unclassified' }
TMbndModule >> generateAnonymousSymbolName [
	| result |
	anonSymbolCount ifNil: [ anonSymbolCount := 0 ].
	result := ('..anon.' , anonSymbolCount asString, '..') asSymbol.
	anonSymbolCount := anonSymbolCount + 1.
	^ result
]

{ #category : #'as yet unclassified' }
TMbndModule >> generateTargetCodeModule [
	| codeGenerator |
	codeGenerator := self compilationTarget newCodeModuleGenerator.
	^ MbndProfiler component: #irCodeGeneration with: [codeGenerator generateCodeModuleFor: self]
]

{ #category : #'as yet unclassified' }
TMbndModule >> generateTargetCodeModuleForProgramEntities: programEntitities [
	| codeGenerator |
	codeGenerator := self compilationTarget newCodeModuleGenerator.
	^ codeGenerator generateCodeModuleFor: self programEntities: programEntitities name: #main
]

{ #category : #parsing }
TMbndModule >> getLanguageNamedFromCache: languageName [
	^ self languageInterfaceCache at: languageName ifAbsentPut: [
		(MbndLanguageInterface languageNamed: languageName) new
	]
]

{ #category : #accessing }
TMbndModule >> globalNamespace [
	^ globalNamespace ifNil: [ globalNamespace := MbndNamespace new
			name: #__global;
			module: self;
			yourself
	]
]

{ #category : #'gt inspector extensions' }
TMbndModule >> gtTreeViewIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'Program Entities';
		display: [ :node | self ];
		children: [ :each | each children];
		format: [ :node | node asString ]
]

{ #category : #parameters }
TMbndModule >> hasConservativeGarbageCollector [
	^ self hasGarbageCollectionSupport and: [ self hasPreciseGarbageCollector not or: [ self hasGarbageCollectionStackMap not ] ]
]

{ #category : #testing }
TMbndModule >> hasExceptions [
	^ true
]

{ #category : #parameters }
TMbndModule >> hasGPUSupport [
	^ true
]

{ #category : #parameters }
TMbndModule >> hasGarbageCollectionStackMap [
	<compileTime>
	^ false
]

{ #category : #parameters }
TMbndModule >> hasGarbageCollectionSupport [
	<compileTime>
	^ true
]

{ #category : #parameters }
TMbndModule >> hasLibC [
	^ true
]

{ #category : #parameters }
TMbndModule >> hasRuntimeTypeInformation [
	<compileTime>
	^ true
]

{ #category : #parameters }
TMbndModule >> hasStandardLibrary [
	<compileTime>
	^ true
]

{ #category : #parsing }
TMbndModule >> languageInterfaceCache [
	^ languageInterfaceCache ifNil: [ languageInterfaceCache := Dictionary new ]
]

{ #category : #'member symbols' }
TMbndModule >> lookupSymbol: aSymbol [
	aSymbol = #Compiler ifTrue: [ ^ self compilationEnvironment ].
	^ nil
]

{ #category : #accessing }
TMbndModule >> mainSourceFileName [

	^ mainSourceFileName
]

{ #category : #accessing }
TMbndModule >> mainSourceFileName: anObject [

	mainSourceFileName := anObject
]

{ #category : #accessing }
TMbndModule >> module [
	^ self
]

{ #category : #accessing }
TMbndModule >> moduleLevelInlineAssembly [
	^ moduleLevelInlineAssembly ifNil: [ moduleLevelInlineAssembly := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
TMbndModule >> moduleScope [
	^ MbndModuleScope new module: self
]

{ #category : #scope }
TMbndModule >> newGenericAnalysisScope [
	^ self newSourceEvaluationScopeForLanguageScope: (MbndGenericMacroLanguageTopLevelScope for: self)
]

{ #category : #scope }
TMbndModule >> newGenericSemanticAnalyzer [
	^ MbndAstSemanticAnalyzer new
		scope: self newGenericAnalysisScope;
		module: self;
		yourself
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguage: aLanguage [
	^ self newSourceEvaluationScopeForLanguage: aLanguage withWorkingDirectory: nil
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguage: aLanguage withWorkingDirectory: workingDirectory [
	| languageScope |
	languageScope := aLanguage topLevelLanguageScopeFor: self.
	^ self newSourceEvaluationScopeForLanguageScope: languageScope withWorkingDirectory: workingDirectory
	
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguageNamed: aLanguage [
	^ self newSourceEvaluationScopeForLanguage: (self getLanguageNamedFromCache: aLanguage)
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguageScope: languageScope [
	^ self newSourceEvaluationScopeForLanguageScope: languageScope withWorkingDirectory: nil
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguageScope: languageScope withWorkingDirectory: workingDirectory [
	| moduleScope namespaceScope |
	moduleScope := self programEntityScope parent: languageScope.
	workingDirectory ifNotNil: [ 
		moduleScope := (MbndWorkingDirectoryScope parent: moduleScope)
			workingDirectory: workingDirectory;
			yourself
	].

	namespaceScope := self globalNamespace programEntityScope parent: moduleScope.
	
	^ namespaceScope newReturnContextScope newLexicalScope
	
]

{ #category : #'as yet unclassified' }
TMbndModule >> parent [
	^ nil
]

{ #category : #parsing }
TMbndModule >> parseFileNamed: fileName [
	| language fileReference |
	fileReference := fileName asFileReference.
	language := self getLanguageNamedFromCache: (MbndLanguageInterface languageForFileExtension: fileReference extension) languageName.
	^ language parseFromFileReference: fileReference forModule: self
]

{ #category : #parsing }
TMbndModule >> parseLanguage: languageName source: sourceString [
	| language |
	language := self getLanguageNamedFromCache: languageName.
	^ language parseSourceString: sourceString forModule: self
]

{ #category : #'semantic analysis' }
TMbndModule >> pendingDelayedSemanticAnalysisSet [
	^ pendingDelayedSemanticAnalysisSet ifNil: [ pendingDelayedSemanticAnalysisSet := SLVMOrderedInsertionSet new ]
]

{ #category : #scope }
TMbndModule >> programEntityScopeClass [
	^ MbndNamespaceScope 
]

{ #category : #'as yet unclassified' }
TMbndModule >> recordCreatedType: type [
	type isGCClassType ifTrue: [
		self addedGCClasses add: type.
	].

	type isClassType ifTrue: [ 
		self addedClasses add: type.
	].
]

{ #category : #'semantic analysis' }
TMbndModule >> recordEntityWithPendingDefinitionFragments: anEntity [
	self entitiesWithPendingDefinitionFragments add: anEntity
]

{ #category : #extensions }
TMbndModule >> recordExtensionFor: parentEntity macroMethod: macroMethod withSelector: selector [
	self assert: macroMethod module == self.
	self extensionMacros add: { parentEntity . selector . macroMethod }
]

{ #category : #extensions }
TMbndModule >> recordExtensionFor: parentEntity method: method withSelector: selector [
	self assert: method module == self.
	self extensionMethods add: { parentEntity . selector . method }
]

{ #category : #extensions }
TMbndModule >> recordExtensionFor: parentEntity overloadedMethod: method withSelector: selector [
	self assert: method module == self.
	self extensionOverloadedMethods add: { parentEntity . selector . method }
]

{ #category : #extensions }
TMbndModule >> recordSpecialNonTrivialStructure: specialStructure [
	self specialNonTrivialStructures add: specialStructure
]

{ #category : #extensions }
TMbndModule >> recordSpecialStructure: specialStructure [
	self specialStructures add: specialStructure
]

{ #category : #extensions }
TMbndModule >> recordTemplate: template instanceDefinition: templateInstance [
	self assert: templateInstance module == self.
	self externalTemplateInstances add: { template . templateInstance }
]

{ #category : #extensions }
TMbndModule >> specialStructures [
	^ specialStructures := OrderedCollection new.
]

{ #category : #parameters }
TMbndModule >> useLibC [
	^ true
]
