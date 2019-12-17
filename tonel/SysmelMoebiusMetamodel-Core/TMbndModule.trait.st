Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace',
		'evaluatedFileSet',
		'pendingDelayedSemanticAnalysisSet',
		'languageInterfaceCache',
		'moduleLevelInlineAssembly'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
TMbndModule >> accept: aVisitor [
	^ aVisitor visitModule: self
]

{ #category : #adding }
TMbndModule >> addModuleLevelInlineAssembly: node [
	self moduleLevelInlineAssembly add: node
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
	^ analyzerAndEvaluator analyzeAndEvaluateFunctionContent: ast

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

{ #category : #'as yet unclassified' }
TMbndModule >> children [
	^ { self globalNamespace }
]

{ #category : #'as yet unclassified' }
TMbndModule >> compilationTarget [
	self explicitRequirement
]

{ #category : #'semantic analysis' }
TMbndModule >> enqueueDelayedSemanticAnalysis [
]

{ #category : #'semantic analysis' }
TMbndModule >> enqueueProgramEntityWithDelayedSemanticAnalysis: programEntity [
	self pendingDelayedSemanticAnalysisSet add: programEntity
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

{ #category : #'semantic analysis' }
TMbndModule >> finishSemanticAnalysis [
	| toAnalyze |
	[ self pendingDelayedSemanticAnalysisSet isNotEmpty ] whileTrue: [
		toAnalyze := self pendingDelayedSemanticAnalysisSet asArray.
		self pendingDelayedSemanticAnalysisSet removeAll.
		
		toAnalyze do: #ensureSemanticAnalysis
	]
]

{ #category : #'as yet unclassified' }
TMbndModule >> generateTargetCodeModule [
	| codeGenerator |
	codeGenerator := self compilationTarget newCodeModuleGenerator.
	^ codeGenerator generateCodeModuleFor: self
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
	aSymbol = #Compiler ifTrue: [ ^ self ].
	^ nil
]

{ #category : #accessing }
TMbndModule >> module [
	^ self
]

{ #category : #accessing }
TMbndModule >> moduleLevelInlineAssembly [
	^ moduleLevelInlineAssembly ifNil: [ moduleLevelInlineAssembly := OrderedCollection new ]
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

{ #category : #parameters }
TMbndModule >> useLibC [
	^ true
]
