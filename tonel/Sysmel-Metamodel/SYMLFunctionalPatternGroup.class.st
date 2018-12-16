Class {
	#name : #SYMLFunctionalPatternGroup,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'alternatives',
		'fallbackPattern'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #adding }
SYMLFunctionalPatternGroup >> addAllAlternativesWithPublicSelector: publicSelector into: methodCollection [
	alternatives ifEmpty: [
		self halt.
	].
	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [ 
		^ alternatives first addSingleAlternativeWithPublicSelector: publicSelector into: methodCollection
	].

	alternatives do: [ :alternative |
		alternative addAlternativeIntoMethodCollection: methodCollection
		
	].

	self flag: 'TODO: Construct the dynamic alternative'
]

{ #category : #adding }
SYMLFunctionalPatternGroup >> addPatternAlternative: aPatternAlternative [
	alternatives do: [ :existentAlternative |
		aPatternAlternative checkConflictWith: existentAlternative
	].

	alternatives := alternatives copyWith: aPatternAlternative.
]

{ #category : #adding }
SYMLFunctionalPatternGroup >> addPatternAlternative: aMacroFunction withFunctionType: functionType [
	| macroFunction |
	macroFunction := SYMLFunctionalPatternGroupFunctionTypedAlternative new
		macroFunction: aMacroFunction;
		functionType: functionType;
		yourself.
	^ self addPatternAlternative: macroFunction
]

{ #category : #adding }
SYMLFunctionalPatternGroup >> addTemplatePatternAlternative: aMacroFunction [
	| macroFunction |
	macroFunction := SYMLFunctionalPatternGroupTemplateAlternative new
		macroFunction: aMacroFunction;
		yourself.
	^ self addPatternAlternative: macroFunction
]

{ #category : #enumerating }
SYMLFunctionalPatternGroup >> allAlternativesDo: aBlock [
	alternatives do: aBlock.
	fallbackPattern ifNotNil: [ aBlock value: fallbackPattern ].
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> alternatives [
	^ alternatives
]

{ #category : #'macro compilation' }
SYMLFunctionalPatternGroup >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #converting }
SYMLFunctionalPatternGroup >> asCompiledMethod [
	^ nil
]

{ #category : #'as yet unclassified' }
SYMLFunctionalPatternGroup >> evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ self asSysmelValueInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> fallbackPattern [
	^ fallbackPattern
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> fallbackPattern: anObject [
	fallbackPattern := anObject
]

{ #category : #'virtual methods' }
SYMLFunctionalPatternGroup >> findAlternativeMatchedByOverridingMethod: derivedMethod [
	alternatives do: [ :alternative |
		(alternative isMatchedByOverridingMethod: derivedMethod) ifTrue: [ 
			^ alternative
		]
	].

	^ nil
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findPatternForMessage: message inEnvironment: environment at: aPosition [
	"Handle quickly the case without alternatives"
	| expansionCache validAlternatives selectedAlternative |
	alternatives ifEmpty: [ ^ {message . fallbackPattern} ].
	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [ ^ {message . alternatives first} ].
	
	expansionCache := Array new: message arguments size.
	validAlternatives := alternatives collect: [ :alternative |
		alternative matchUnexpandedArguments: message arguments withExpansionCache: expansionCache inEnvironment: environment
	] thenSelect: #isNotNil.

	validAlternatives ifNotEmpty: [
		selectedAlternative := self selectBestMatchingAlternative: validAlternatives at: aPosition.
		^ { message . selectedAlternative }
	].
		
	"Use the fallback pattern"
	fallbackPattern ifNotNil: [ 
		^ {message . fallbackPattern }
	].
	
	self error: 'Not matching alternative for calling overloaded method {1}.' format: { name } at: aPosition
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findPatternWithArgumentTypes: argumentTypes at: aPosition [
	"Handle quickly the case without alternatives"
	| validAlternatives |
	alternatives ifEmpty: [ ^ fallbackPattern ].
	(fallbackPattern isNil and: [ alternatives size = 1 ]) ifTrue: [ ^ alternatives first ].
	
	validAlternatives := alternatives collect: [ :alternative |
		alternative matchArgumentTypes: argumentTypes
	] thenSelect: #isNotNil.

	validAlternatives ifNotEmpty: [
		^ self selectBestMatchingAlternative: validAlternatives at: aPosition.
	].
		
	"Use the fallback pattern"
	fallbackPattern ifNotNil: [ 
		^ fallbackPattern
	].
	
	^ nil
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findValidPatternForMessage: message inEnvironment: environment at: aPosition [
	| messageAndPattern |
	messageAndPattern := self findPatternForMessage: message inEnvironment: environment at: aPosition.
	messageAndPattern ifNil: [
		^ self error: 'Cannot find matching alternative of {1}.' format: { name printString } at: aPosition
	].

	^ messageAndPattern
]

{ #category : #'pattern finding' }
SYMLFunctionalPatternGroup >> findValidPatternWithArgumentTypes: argumentTypes at: aPosition [
	| pattern |
	pattern := self findPatternWithArgumentTypes: argumentTypes at: aPosition.
	pattern ifNil: [
		^ self error: 'Cannot find matching alternative of {1}.' format: { name printString } at: aPosition
	].

	^ pattern
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroup >> generateSSACode [
	self allAlternativesDo: #generateSSACode
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> generateSimpleSSACallWithArguments: ssaVariable with: builder [
	self assert: (fallbackPattern isNil and: [ alternatives size = 1 ]).
	^ self alternatives first macroFunction generateSimpleSSACallWithArguments: ssaVariable with: builder
]

{ #category : #initialization }
SYMLFunctionalPatternGroup >> initialize [
	super initialize.
	alternatives := #().
]

{ #category : #testing }
SYMLFunctionalPatternGroup >> isFunctionalPatternGroup [
	^ true
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroup >> isNonTrivialConstructorOrDestructor [
	self assert: fallbackPattern isNil.
	self assert: alternatives size = 1.
	^ alternatives first macroFunction isNonTrivialConstructorOrDestructor
]

{ #category : #'as yet unclassified' }
SYMLFunctionalPatternGroup >> selectBestMatchingAlternative: validAlternatives at: aPosition [
	| bestCost bestAlternatives errorMessage |
	bestCost := SmallInteger maxVal.
	validAlternatives do: [ :pair |
		pair second < bestCost ifTrue: [ bestCost := pair second].
	].

	bestAlternatives := validAlternatives select: [ :pair | pair second = bestCost ].
	bestAlternatives size = 1 ifTrue: [
		^ bestAlternatives first first
	].
	
	bestAlternatives ifEmpty: [ 
		self error: 'No matching overloaded alternative is available for function/macro {1}.' format: { name } at: aPosition
	].

	errorMessage := ByteString streamContents: [ :out |
		out << ('Ambiguous matching overloaded alternatives are available for function/macro {1}:' format: { name }).
		out lf.
		bestAlternatives do: [ :alternative |
			out tab nextPutAll: ('{1} defined at {2}' format: {alternative first macroFunction printString . alternative first macroFunction definitionPosition printString }); lf
		]
	].

	self error: errorMessage at: aPosition
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroup >> semanticAnalysis [
	self allAlternativesDo: #semanticAnalysis
]

{ #category : #'semantic analysis' }
SYMLFunctionalPatternGroup >> semanticAnalyzeAddress: node inEnvironment: environment at: aPosition [
	((fallbackPattern isNotNil and: [ alternatives isNotEmpty ]) or: [ alternatives size ~= 1 ]) ifTrue: [ 
		self error: 'Cannot get the address of an ambiguous functional group.' at: aPosition
	].

	fallbackPattern ifNotNil: [
		^ fallbackPattern semanticAnalyzeAddress: node inEnvironment: environment at: aPosition
	].
	^ alternatives first semanticAnalyzeAddress: node inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLFunctionalPatternGroup >> ssaValue [
	self assert: (fallbackPattern isNil and: [ alternatives size = 1 ]).
	^ self alternatives first macroFunction ssaValue
]

{ #category : #'as yet unclassified' }
SYMLFunctionalPatternGroup >> uniqueAlternative [
	<compileTime>
	(alternatives size = 1 and: [fallbackPattern isNil]) ifTrue: [ ^ alternatives first ].
	alternatives ifEmpty: [ ^ fallbackPattern ].
	self error: 'Overloaded meta object has not unique alternatives'.
]
