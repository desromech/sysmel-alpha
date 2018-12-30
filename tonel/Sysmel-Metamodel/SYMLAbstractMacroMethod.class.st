Class {
	#name : #SYMLAbstractMacroMethod,
	#superclass : #SYMLMacro,
	#traits : 'TSYMLMessageMethod',
	#classTraits : 'TSYMLMessageMethod classTrait',
	#instVars : [
		'hasSelector',
		'arguments',
		'macroFunctionType'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'as yet unclassified' }
SYMLAbstractMacroMethod >> bodyEnvironment [
	^ definitionEnvironment
]

{ #category : #'macro methods' }
SYMLAbstractMacroMethod >> convertMacroArgument: providedArgument into: expectedArgumentType in: environment [
	| evaluatedArgument coercedArgument |
	expectedArgumentType isAPSGNodeType ifTrue: [ ^ providedArgument ].
	
	evaluatedArgument := providedArgument analyzeAndEvaluateInEnvironment: environment.
	coercedArgument := evaluatedArgument coercedIntoType: expectedArgumentType at: providedArgument position.
	^ coercedArgument
]

{ #category : #'macro methods' }
SYMLAbstractMacroMethod >> createActivationEnvironmentForMessage: message inEnvironment: environment at: aPosition [
	| activationScope activationArguments providedArgument convertedArgument |
	activationScope := SYMLFunctionActivationScope parent: self bodyEnvironment.
	activationScope function: self.

	"Add the apsgBuilder"
	activationScope addSymbol: #__apsgBuilder value: (SYMLAPSGBuilder new
		environment: environment;
		gensymEnvironment: activationScope;
		yourself).
	message receiver ifNotNil: [
		self flag: 'Allow evaluation self'.
		activationScope
			addSymbol: #self value: message receiver;
			addSymbol: #SelfType value: (message receiver type asAPSGNodeInEnvironment: environment at:  aPosition)
	].

	activationArguments := message arguments.
	(arguments size ~= activationArguments size and: [ self isVariadic not or: [ activationArguments size < arguments size ] ]) ifTrue: [
		self error: 'Mismatching number of arguments.' at: aPosition
	].

	arguments doWithIndex: [:expectedArgument :index |
		providedArgument := activationArguments at: index.
		convertedArgument := self convertMacroArgument: providedArgument into: expectedArgument type in: environment.
		activationScope addSymbol: expectedArgument name value: convertedArgument.
	].

	^ activationScope
]

{ #category : #'as yet unclassified' }
SYMLAbstractMacroMethod >> createMacroFunctionType [
	macroFunctionType := self compilationTarget macroFunctionArguments: (arguments collect: #type).
]

{ #category : #'argument parsing' }
SYMLAbstractMacroMethod >> defaultTypeForArgument: node inEnvironment: environment [
	^ self compilationTarget apsgNodeType
]

{ #category : #initialization }
SYMLAbstractMacroMethod >> initialize [
	super initialize.
	hasSelector := false.
]

{ #category : #'macro methods' }
SYMLAbstractMacroMethod >> isVariadic [
	^ false
]

{ #category : #accessing }
SYMLAbstractMacroMethod >> macroFunctionType [
	^ macroFunctionType
]

{ #category : #'as yet unclassified' }
SYMLAbstractMacroMethod >> sanitizeExpansion: expansion at: aPosition [
	(expansion isSequenceNode and: [ expansion elements size = 1 ]) ifTrue: [
		^ expansion elements first shallowCopy
		position: aPosition;
		yourself
	].

	^ expansion shallowCopy
		position: aPosition;
		yourself
]

{ #category : #'meta object protocol' }
SYMLAbstractMacroMethod >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	hasSelector ifFalse: [ 
		self setSelectorWithTemplate: message inEnvironment: environment at: aPosition.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #initialization }
SYMLAbstractMacroMethod >> setSelectorWithTemplate: message inEnvironment: environment at: aPosition [
	arguments := message arguments collect: [ :arg | self createArgumentFromTemplate: arg inEnvironment: environment ].
	
	self createMacroFunctionType.
	self name: message selector.
	hasSelector := true.
	
]
