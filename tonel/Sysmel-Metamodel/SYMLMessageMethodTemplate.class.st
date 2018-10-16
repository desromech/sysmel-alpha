Class {
	#name : #SYMLMessageMethodTemplate,
	#superclass : #SYMLAbstractFunctionTemplate,
	#traits : 'TSYMLMessageMethod',
	#classTraits : 'TSYMLMessageMethod classTrait',
	#instVars : [
		'hasSelector',
		'selectorTemplateNode',
		'selectorTemplateEnvironment'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'argument parsing' }
SYMLMessageMethodTemplate >> createArgumentFromMessageTemplate: argumentNode inEnvironment: environment [
	| argumentName argumentType |
	argumentNode receiver ifNotNil: [
		self error: 'Expected a message without receiver for the argument name.' at: argumentNode
	].

	(argumentNode selector numArgs ~= 1 or: [ (argumentNode selector includes: $:) not ]) ifTrue: [
		self error: 'Expected an unary selector for the argument {1} name' format: { argumentNode selector printString } at: argumentNode
	].
	
	argumentName := argumentNode selector allButLast asSymbol.
	argumentType := argumentNode arguments first analyzeAndEvaluateInEnvironment: environment.
	(argumentType value isType or: [argumentType value isSysmelIncompleteValue]) ifFalse: [ 
		self error: 'Expected a type or an incomplete type for the argument {1}' format: { argumentNode selector printString } at: argumentNode arguments first
	].
		
	^ argumentType value
]

{ #category : #'as yet unclassified' }
SYMLMessageMethodTemplate >> createInstanceWithEnvironment: instanceEnvironment [
	| instance |
	instance := SYMLMessageMethod new
		module: module;
		definitionEnvironment: instanceEnvironment;
		definitionNode: definitionNode;
		templateFunctionOwner: self;
		parent: (parent ifNil: [instanceEnvironment definitionProgramEntity]);
		setSelectorWithTemplate: selectorTemplateNode inEnvironment: instanceEnvironment at: definitionPosition;
		yourself.
	returnType ifNotNil: [ 
		instance -> (returnType lazyValueForEnvironment: instanceEnvironment)
	].
	bodyValue ifNotNil: [
		instance assignValue: (bodyValue lazyValueForEnvironment: instanceEnvironment)
	].

	^ instance
]

{ #category : #'argument parsing' }
SYMLMessageMethodTemplate >> defaultTypeForArgument: node inEnvironment: environment [
	self error: 'Explicit type for argument is required.' at: node
]

{ #category : #initialization }
SYMLMessageMethodTemplate >> initialize [
	super initialize.
	hasSelector := false.
]

{ #category : #'as yet unclassified' }
SYMLMessageMethodTemplate >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	hasSelector ifFalse: [ 
		self setSelectorWithTemplate: message inEnvironment: environment at: aPosition.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #initialization }
SYMLMessageMethodTemplate >> setSelectorWithTemplate: message inEnvironment: environment at: aPosition [
	| argumentParseEnvironment |
	selectorTemplateNode := message.
	selectorTemplateEnvironment := environment.
	argumentParseEnvironment := self createArgumentParseEnvironmentFor: environment.
	arguments := message arguments collect: [ :arg |
		self createArgumentFromTemplate: arg inEnvironment: argumentParseEnvironment
	].
	
	self name: message selector.
	hasSelector := true.
	
]

{ #category : #accessing }
SYMLMessageMethodTemplate >> tryToAddToParentWithName: aNewName [
	arguments ifNil: [ ^ self ].
	parent addMacroMethodPattern: self withSelector: aNewName.
]
