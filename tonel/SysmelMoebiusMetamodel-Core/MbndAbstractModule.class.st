Class {
	#name : #MbndAbstractModule,
	#superclass : #Object,
	#traits : 'TMbndModule',
	#classTraits : 'TMbndModule classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #evaluation }
MbndAbstractModule >> analyzeAndEvaluateAST: ast [
	| parsedSource |
	parsedSource := MbndLanguageParsedSource new
		ast: ast;
		language: MbndGenericMacroLanguageInterface new.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #evaluation }
MbndAbstractModule >> analyzeAndEvaluateAST: ast inScope: scope [
	| analyzerAndEvaluator |
	analyzerAndEvaluator := MbndAstSemanticAnalyzerAndEvaluator new
		module: self;
		scope: scope.
	^ MbndProfiler component: #analysisAndEvaluation with: [analyzerAndEvaluator analyzeAndEvaluateFunctionContent: ast]

]

{ #category : #'as yet unclassified' }
MbndAbstractModule >> generateTargetCodeModule [
	| codeGenerator |
	codeGenerator := self compilationTarget newCodeModuleGenerator.
	^ MbndProfiler component: #irCodeGeneration with: [codeGenerator generateCodeModuleFor: self]
]
