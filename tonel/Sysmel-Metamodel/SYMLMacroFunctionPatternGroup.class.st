Class {
	#name : #SYMLMacroFunctionPatternGroup,
	#superclass : #SYMLFunctionalPatternGroup,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'as yet unclassified' }
SYMLMacroFunctionPatternGroup >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ identifier copyWithBinding: self andType: self compilationTarget functionGroupType
]

{ #category : #'as yet unclassified' }
SYMLMacroFunctionPatternGroup >> semanticAnalyzeApplication: message inEnvironment: environment at: aPosition [
	"Handle the non-overloded case first."
	alternatives ifEmpty: [
		^ self semanticAnalyzeApplicationAlternative: fallbackPattern message: message inEnvironment: environment at: aPosition
	].

	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [
		^ self semanticAnalyzeApplicationAlternative: alternatives first macroFunction message: message inEnvironment: environment at: aPosition
	].

	^ self semanticAnalyzeOverloadedApplication: message inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLMacroFunctionPatternGroup >> semanticAnalyzeApplicationAlternative: selectedAlternative message: message inEnvironment: environment at: aPosition [
	^ (message shallowCopy
		receiver: (message receiver bindIntoOverloadedAlternative: selectedAlternative inEnvironment: environment)
		yourself) semanticAnalysisInEnvironment: environment
]

{ #category : #'as yet unclassified' }
SYMLMacroFunctionPatternGroup >> semanticAnalyzeOverloadedApplication: message inEnvironment: environment at: aPosition [
	| tupleArgument expansionCache validAlternatives selectedAlternative |
	self assert: message arguments size = 1.
	tupleArgument := message arguments first.
	tupleArgument isTupleNode ifTrue: [
		expansionCache := Array new: tupleArgument elements size.
		validAlternatives := alternatives collect: [ :alternative |
			alternative matchUnexpandedArguments: tupleArgument elements withExpansionCache: expansionCache inEnvironment: environment
		] thenSelect: #isNotNil.

		"Select the best alternative"	
		validAlternatives ifNotEmpty: [
			selectedAlternative := self selectBestMatchingAlternative: validAlternatives at: aPosition.
			^ self semanticAnalyzeApplicationAlternative: selectedAlternative macroFunction message: message inEnvironment: environment at: aPosition
		].
		
		"Use the fallback pattern"
		fallbackPattern ifNotNil: [ 
			^ self semanticAnalyzeApplicationAlternative: fallbackPattern message: message inEnvironment: environment at: aPosition
		].
	
		self error: 'Not matching alternative for calling overloaded function {1}.' format: { name } at: aPosition
	] ifFalse: [
		self halt.
	].
]
