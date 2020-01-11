Class {
	#name : #MbndSmalltalkImageModule,
	#superclass : #Object,
	#traits : 'TMbndModule',
	#classTraits : 'TMbndModule classTrait',
	#instVars : [
		'typesForBehaviors',
		'compilationTarget'
	],
	#classInstVars : [
		'uniqueInstance',
		'systemUniqueInstance'
	],
	#category : #'SysmelMoebiusMetamodel-Core-In-Image'
}

{ #category : #singleton }
MbndSmalltalkImageModule class >> new [
	self error: 'You cannot create an instance from me. Use uniqueInstance.'
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> reset [ 
	uniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> setUpCleanForTest [
	systemUniqueInstance := uniqueInstance.
	uniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> tearDownCleanForTest [
	uniqueInstance := systemUniqueInstance.
	systemUniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #evaluation }
MbndSmalltalkImageModule >> analyzeAndEvaluateAST: ast [
	| parsedSource |
	parsedSource := MbndLanguageParsedSource new
		ast: ast;
		language: MbndGenericMacroLanguageInterface new.
	^ self analyzeAndEvaluateParsedSource: parsedSource
]

{ #category : #evaluation }
MbndSmalltalkImageModule >> analyzeAndEvaluateAST: ast inScope: scope [
	| analyzerAndEvaluator |
	analyzerAndEvaluator := MbndAstSemanticAnalyzerAndEvaluator new
		module: self;
		scope: scope.
	^ MbndProfiler component: #analysisAndEvaluation with: [analyzerAndEvaluator analyzeAndEvaluateFunctionContent: ast]

]

{ #category : #'as yet unclassified' }
MbndSmalltalkImageModule >> compilationTarget [
	compilationTarget ifNil: [
		compilationTarget := MbndInImageCompilationTarget basicNew.
		compilationTarget
			coreDefinitionsModule: self;
			initialize
	].

	^ compilationTarget
]

{ #category : #'as yet unclassified' }
MbndSmalltalkImageModule >> generateTargetCodeModule [
	| codeGenerator |
	codeGenerator := self compilationTarget newCodeModuleGenerator.
	^ MbndProfiler component: #irCodeGeneration with: [codeGenerator generateCodeModuleFor: self]
]

{ #category : #initialization }
MbndSmalltalkImageModule >> initialize [
	super initialize.
	typesForBehaviors := WeakKeyDictionary new.
]

{ #category : #accessing }
MbndSmalltalkImageModule >> typeForBehavior: aBehavior [
	^ typesForBehaviors at: aBehavior ifAbsentPut: [ MbndImageBehaviorType new
			definitionModule: self;
			behavior: aBehavior;
			yourself
	]
]
