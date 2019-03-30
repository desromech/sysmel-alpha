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
	#category : #'MoebiusBandMetamodel-Core-In-Image'
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

{ #category : #accessing }
MbndSmalltalkImageModule >> compilationTarget [
	compilationTarget ifNil: [
		compilationTarget := MbndInImageCompilationTarget basicNew.
		compilationTarget
			coreDefinitionsModule: self;
			initialize
	].

	^ compilationTarget
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
