Class {
	#name : #MbndAbstractModule,
	#superclass : #Object,
	#traits : 'TMbndModule',
	#classTraits : 'TMbndModule classTrait',
	#category : #'MoebiusBandMetamodel-Core-Module'
}

{ #category : #evaluation }
MbndAbstractModule >> analyzeAndEvaluateAST: ast [
	| parsedSource |
	parsedSource := MbndLanguageParsedSource new
		ast: ast;
		language: MbndGenericMacroLanguageInterface new.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]
