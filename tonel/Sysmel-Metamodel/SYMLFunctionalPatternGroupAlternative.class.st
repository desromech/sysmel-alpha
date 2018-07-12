Class {
	#name : #SYMLFunctionalPatternGroupAlternative,
	#superclass : #SYMLObject,
	#instVars : [
		'macroFunction'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroupAlternative >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroupAlternative >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	^ macroFunction analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLFunctionalPatternGroupAlternative >> checkConflictWith: aPatternAlternative [
	(self matchesSameAs: aPatternAlternative) ifTrue: [ 
		macroFunction error: 'Adding conflicting macro/function/method alternative {1}.' format: { macroFunction printString} at: macroFunction definitionPosition
	].
]

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroupAlternative >> evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition [
	^ macroFunction evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition
]

{ #category : #testing }
SYMLFunctionalPatternGroupAlternative >> expandArgument: argument index: index withExpansionCache: expansionCache inEnvironment: environment [
	| expandedArgument expandedArgumentType pair |
	(expansionCache at: index) ifNotNil: [ :cachedExpansion | ^ cachedExpansion].
	expandedArgument := argument semanticAnalysisInEnvironment: environment.
	expandedArgumentType := expandedArgument evaluateTypeInEnvironment: environment.
	pair := { expandedArgument . expandedArgumentType}.
	expansionCache at: index put: pair.
	^ pair
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroupAlternative >> generateSSACode [
	macroFunction generateSSACode
]

{ #category : #accessing }
SYMLFunctionalPatternGroupAlternative >> macroFunction [
	^ macroFunction
]

{ #category : #accessing }
SYMLFunctionalPatternGroupAlternative >> macroFunction: anObject [
	macroFunction := anObject
]

{ #category : #testing }
SYMLFunctionalPatternGroupAlternative >> matchesSameAs: aPatternAlternative [
	self subclassResponsibility
	
]

{ #category : #testing }
SYMLFunctionalPatternGroupAlternative >> matchesSameAsFunctionTypedAlternative: otherAlternative [
	^ false
]

{ #category : #testing }
SYMLFunctionalPatternGroupAlternative >> matchesSameAsTemplateAlternative: otherAlternative [
	^ false
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroupAlternative >> semanticAnalysis [
	macroFunction semanticAnalysis
]

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroupAlternative >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ macroFunction semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLFunctionalPatternGroupAlternative >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	^ macroFunction semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLFunctionalPatternGroupAlternative >> ssaValue [
	^ macroFunction ssaValue
]
