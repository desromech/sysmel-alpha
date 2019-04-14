Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

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
	^ self analyzeAndEvaluateAST: parsedSource ast inScope: (self newSourceEvaluationScopeForLanguage: parsedSource language)
]

{ #category : #accessing }
TMbndModule >> compilationTarget [
	self explicitRequirement
]

{ #category : #evaluation }
TMbndModule >> evaluateLanguage: languageName source: sourceString [
	| parsedSource |
	parsedSource := self parseLanguage: languageName source: sourceString.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #accessing }
TMbndModule >> globalNamespace [
	^ globalNamespace ifNil: [ globalNamespace := MbndNamespace new
			name: #__global;
			module: self;
			yourself
	]
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
	| languageScope |
	languageScope := aLanguage topLevelLanguageScopeFor: self.
	^ self newSourceEvaluationScopeForLanguageScope: languageScope
	
]

{ #category : #scope }
TMbndModule >> newSourceEvaluationScopeForLanguageScope: languageScope [
	| moduleScope namespaceScope |
	moduleScope := self programEntityScope parent: languageScope.
	namespaceScope := self globalNamespace programEntityScope parent: moduleScope.
	^ namespaceScope newReturnContextScope newLexicalScope
	
]

{ #category : #parsing }
TMbndModule >> parseFileNamed: fileName [
	| language fileReference |
	fileReference := fileName asFileReference.
	language := MbndLanguageInterface languageForFileExtension: fileReference extension.
	^ language parseFromFileReference: fileReference forModule: self
]

{ #category : #parsing }
TMbndModule >> parseLanguage: languageName source: sourceString [
	| language |
	language := MbndLanguageInterface languageNamed: languageName.
	^ language parseSourceString: sourceString forModule: self
]

{ #category : #scope }
TMbndModule >> programEntityScopeClass [
	^ MbndModuleScope
]
