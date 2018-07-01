Class {
	#name : #SYMLFunctionalPatternGroupTemplateAlternative,
	#superclass : #SYMLFunctionalPatternGroupAlternative,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #converting }
SYMLFunctionalPatternGroupTemplateAlternative >> asMatchedAlternativeWith: patternMatchingContext [
	^ SYMLFunctionalPatternGroupTemplateMatchedAlternative new
		alternative: self;
		patternMatchingContext: patternMatchingContext;
		yourself
]

{ #category : #testing }
SYMLFunctionalPatternGroupTemplateAlternative >> matchUnexpandedArguments: suppliedArguments withExpansionCache: expansionCache inEnvironment: environment [
	| coercionCost expectedArgumentCount patternMatchingContext suppliedArgument suppliedArgumentNode suppliedArgumentType argumentCoercionCost |
	expectedArgumentCount := macroFunction requiredArgumentCount.
	suppliedArguments size ~= macroFunction requiredArgumentCount ifTrue: [ ^ nil ].

	coercionCost := 0.
	patternMatchingContext := macroFunction newTemplateMatchingContext.
	1 to: expectedArgumentCount do: [ :i |
		suppliedArgument := self expandArgument: (suppliedArguments at: i) index: i withExpansionCache: expansionCache inEnvironment: environment.
		suppliedArgumentNode := suppliedArgument first.
		suppliedArgumentType := suppliedArgument second.

		argumentCoercionCost := macroFunction matchArgument: i type: suppliedArgumentType node: suppliedArgumentNode withMatchingContext: patternMatchingContext at: suppliedArgumentNode.
		argumentCoercionCost < 0 ifTrue: [ ^ nil ].
		coercionCost := coercionCost + argumentCoercionCost
	].
	
	patternMatchingContext isAllMatched ifFalse: [ ^ nil ].
	^ {self asMatchedAlternativeWith: patternMatchingContext . coercionCost}
]

{ #category : #testing }
SYMLFunctionalPatternGroupTemplateAlternative >> matchesSameAs: aPatternAlternative [
	^ aPatternAlternative matchesSameAsTemplateAlternative: self
]
