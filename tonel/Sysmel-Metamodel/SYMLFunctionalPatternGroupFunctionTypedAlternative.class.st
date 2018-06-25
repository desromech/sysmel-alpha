Class {
	#name : #SYMLFunctionalPatternGroupFunctionTypedAlternative,
	#superclass : #SYMLFunctionalPatternGroupAlternative,
	#instVars : [
		'functionType'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> expandArgument: argument index: index withExpansionCache: expansionCache inEnvironment: environment [
	| expandedArgument expandedArgumentType pair |
	(expansionCache at: index) ifNotNil: [ :cachedExpansion | ^ cachedExpansion].
	expandedArgument := argument semanticAnalysisInEnvironment: environment.
	expandedArgumentType := expandedArgument evaluateTypeInEnvironment: environment.
	pair := { expandedArgument . expandedArgumentType}.
	expansionCache at: index put: pair.
	^ pair
]

{ #category : #accessing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> functionType [
	^ functionType
]

{ #category : #accessing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> functionType: anObject [
	functionType := anObject
]

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> matchUnexpandedArguments: suppliedArguments withExpansionCache: expansionCache inEnvironment: environment [
	| expectedArguments expectedArgument suppliedArgument suppliedArgumentNode suppliedArgumentType coercionCost argumentCoercionRule |
	expectedArguments := functionType arguments.
	suppliedArguments size ~= expectedArguments size ifTrue: [ ^ -1 ].
	coercionCost := 0.
	1 to: expectedArguments size do: [ :i |
		expectedArgument := expectedArguments at: i.
		(expectedArgument isAPSGNodeType and: [macroFunction isMetaMethod ]) ifTrue: [ 
			"This always matches"
		] ifFalse: [ 
			suppliedArgument := self expandArgument: (suppliedArguments at: i) index: i withExpansionCache: expansionCache inEnvironment: environment.
			suppliedArgumentNode := suppliedArgument first.
			suppliedArgumentType := suppliedArgument second.
			argumentCoercionRule := suppliedArgumentType node: suppliedArgumentNode coercedImplicitlyInto: expectedArgument.
			argumentCoercionRule ifNil: [ ^ -1 ].
			coercionCost := coercionCost + argumentCoercionRule coercionCost
		].
	].

	^ coercionCost
]

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> matchesSameAs: aPatternAlternative [
	^ aPatternAlternative matchesSameAsFuncionTypedAlternative: self
]

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> matchesSameAsFuncionTypedAlternative: otherAlternative [
	^ functionType arguments = otherAlternative functionType arguments
]
