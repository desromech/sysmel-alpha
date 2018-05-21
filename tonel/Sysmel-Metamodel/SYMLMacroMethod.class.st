Class {
	#name : #SYMLMacroMethod,
	#superclass : #SYMLMacro,
	#traits : 'TSYMLMessageMethod',
	#classTraits : 'TSYMLMessageMethod classTrait',
	#instVars : [
		'hasSelector',
		'arguments'
	],
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'as yet unclassified' }
SYMLMacroMethod >> bodyEnvironment [
	^ definitionEnvironment
]

{ #category : #'macro methods' }
SYMLMacroMethod >> convertMacroArgument: providedArgument into: expectedArgumentType in: environment [
	expectedArgumentType isAPSGNodeType ifTrue: [ ^ providedArgument ].
	self halt
]

{ #category : #'macro methods' }
SYMLMacroMethod >> createActivationEnvironmentForMessage: message inEnvironment: environment at: aPosition [
	| activationScope activationArguments providedArgument convertedArgument |
	activationScope := SYMLFunctionActivationScope parent: self bodyEnvironment.
	activationScope function: self.

	message receiver ifNotNil: [
		self halt
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

{ #category : #'argument parsing' }
SYMLMacroMethod >> defaultTypeForArgument: node inEnvironment: environment [
	^ self compilationTarget apsgNodeType
]

{ #category : #initialization }
SYMLMacroMethod >> initialize [
	super initialize.
	hasSelector := false.
]

{ #category : #'macro methods' }
SYMLMacroMethod >> isVariadic [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLMacroMethod >> sanitizeExpansion: expansion at: aPosition [
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
SYMLMacroMethod >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	hasSelector ifFalse: [ 
		self setSelectorWithTemplate: message inEnvironment: environment at: aPosition.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #initialization }
SYMLMacroMethod >> setSelectorWithTemplate: message inEnvironment: environment at: aPosition [
	self name: message selector.
	hasSelector := true.
	arguments := message arguments collect: [ :arg | self createArgumentFromTemplate: arg inEnvironment: environment ].
	
]
