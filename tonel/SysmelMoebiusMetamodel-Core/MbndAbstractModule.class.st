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

{ #category : #'as yet unclassified' }
MbndAbstractModule >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]
