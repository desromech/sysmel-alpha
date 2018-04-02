Class {
	#name : #SYMLTemplate,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'hasArguments',
		'body',
		'bodyEnvironment',
		'arguments',
		'cachedResults'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLTemplate >> applyWithArguments: argumentNodes [
	<compileTime>
	<lazy>
	| evaluationEnvironment argumentName argumentType |
	hasArguments ifTrue: [
		^ self evaluateTemplate: argumentNodes
	].

	hasArguments := true.

	evaluationEnvironment := argumentNodes environment.
	argumentNodes node isTupleNode ifFalse: [ 
		self error: 'Expected an APSG tuple.'
	].

	arguments := argumentNodes node elements collect: [ :arg |
		arg isMessageNode ifFalse: [
			self error: 'Expected a message send to describe a function argument.' at: arg.
		].
	
		arg receiver ifNotNil: [ 
			self error: 'Function argument description must not have a receiver.' at: arg.
		].

		arg arguments size ~= 1 ifTrue: [ 
			self error: 'Function argument description must have only a single keyword.' at: arg.
		].
	
		argumentName := arg selector allButLast asSymbol.
		argumentType := arg arguments first analyzeAndEvaluateInEnvironment: evaluationEnvironment.
		argumentType value isType ifFalse: [
			self error: 'Expected a type for argument {1}' format: { argumentName } at: arg arguments first
		].
		
		SYMLFunctionArgument new
			parent: self;
			name: argumentName;
			type: argumentType value;
			definitionNode: arg;
			yourself
	].

]

{ #category : #definition }
SYMLTemplate >> assignValue: theDefinition [
	<compileTime>
	<lazy>
	hasArguments := true.
	body := theDefinition node.
	bodyEnvironment := theDefinition environment
]

{ #category : #'as yet unclassified' }
SYMLTemplate >> evaluateTemplate: theRawArguments [
	| activationArguments activationScope expectedArgument coercedArgument result incompleteResult |
	activationArguments := theRawArguments value.

	activationArguments size ~= arguments size ifTrue: [ 
		self error: 'Mismatching arguments for template {1}. Expected {2} argument(s).' format: { self validName . arguments size asString } at: theRawArguments position
	].

	incompleteResult := cachedResults at: activationArguments ifPresent: [ :existent |
		^ activationArguments
	] ifAbsentPut: [SYMLIncompleteValue new].

	activationScope := SYMLTemplateActivationScope parent: bodyEnvironment.
	activationArguments doWithIndex: [ :argument :index |
		expectedArgument := arguments at: index.
		coercedArgument := argument coercedIntoType: expectedArgument type at: theRawArguments position.
		activationScope addSymbol: expectedArgument name value: (coercedArgument asFunctionActivationValueAt: theRawArguments position).
	].

	result := body copy analyzeAndEvaluateInEnvironment: activationScope.
	result type isMetaObjectType ifTrue: [ 
		result value name: (ByteString streamContents: [:out |
			out nextPutAll: self validName; nextPutAll: ' instance ('.
			activationArguments doWithIndex: [ :arg :index |
				index > 1 ifTrue:[
					out nextPut: $,
				].
			out print: arg value
			].
			out nextPut: $).
		]).
	].

	incompleteResult becomeForward: result value.
	^ result value
]

{ #category : #initialization }
SYMLTemplate >> initialize [
	super initialize.
	hasArguments := false.
	cachedResults := SYMLOrderedDictionary new.
]

{ #category : #'as yet unclassified' }
SYMLTemplate >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [hasArguments not ]) ifTrue: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
