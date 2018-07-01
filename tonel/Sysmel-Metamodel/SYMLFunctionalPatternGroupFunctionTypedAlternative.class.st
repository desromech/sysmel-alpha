Class {
	#name : #SYMLFunctionalPatternGroupFunctionTypedAlternative,
	#superclass : #SYMLFunctionalPatternGroupAlternative,
	#instVars : [
		'functionType'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

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
	suppliedArguments size ~= expectedArguments size ifTrue: [ ^ nil ].
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
			argumentCoercionRule ifNil: [ ^ nil ].
			coercionCost := coercionCost + argumentCoercionRule coercionCost
		].
	].

	^ {self . coercionCost}
]

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> matchesSameAs: aPatternAlternative [
	^ aPatternAlternative matchesSameAsFunctionTypedAlternative: self
]

{ #category : #testing }
SYMLFunctionalPatternGroupFunctionTypedAlternative >> matchesSameAsFunctionTypedAlternative: otherAlternative [
	^ functionType arguments = otherAlternative functionType arguments
]
