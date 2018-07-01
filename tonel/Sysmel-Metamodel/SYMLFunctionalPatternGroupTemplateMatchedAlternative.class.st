Class {
	#name : #SYMLFunctionalPatternGroupTemplateMatchedAlternative,
	#superclass : #SYMLObject,
	#instVars : [
		'alternative',
		'patternMatchingContext'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #accessing }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> alternative [
	^ alternative
]

{ #category : #accessing }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> alternative: anObject [
	alternative := anObject
]

{ #category : #accessing }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> macroFunction [
	^ alternative macroFunction macroFunctionForPatternMatchingContext: patternMatchingContext
]

{ #category : #accessing }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> patternMatchingContext [
	^ patternMatchingContext
]

{ #category : #accessing }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> patternMatchingContext: anObject [
	patternMatchingContext := anObject
]

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroupTemplateMatchedAlternative >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ self macroFunction semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
]
