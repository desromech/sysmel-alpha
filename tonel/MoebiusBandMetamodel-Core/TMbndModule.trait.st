Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'MoebiusBandMetamodel-Core-Module'
}

{ #category : #parsing }
TMbndModule >> analyzeAndEvaluateAST: ast [
	^ self analyzeAndEvaluateAST: ast inScope: self newSourceEvaluationScope
]

{ #category : #parsing }
TMbndModule >> analyzeAndEvaluateAST: ast inScope: scope [
	| analyzerAndEvaluator |
	analyzerAndEvaluator := MbndAstSemanticAnalyzerAndEvaluator new scope: scope.
	^ analyzerAndEvaluator visitNode: ast

]

{ #category : #accessing }
TMbndModule >> compilationTarget [
	self explicitRequirement
]

{ #category : #parsing }
TMbndModule >> evaluateLanguage: languageName source: sourceString [
	| ast |
	ast := self parseLanguage: languageName source: sourceString.
	^ self analyzeAndEvaluateAST: ast
]

{ #category : #accessing }
TMbndModule >> globalNamespace [
	^ globalNamespace ifNil: [ globalNamespace := MbndNamespace new
			name: #__global;
			module: self;
			yourself
	]
]

{ #category : #parsing }
TMbndModule >> newSourceEvaluationScope [
	| moduleScope namespaceScope |
	moduleScope := self programEntityScope.
	namespaceScope := self globalNamespace programEntityScope parent: moduleScope.
	^ namespaceScope newLexicalScope
	
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
