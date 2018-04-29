Class {
	#name : #SYMLFunction,
	#superclass : #SYMLAbstractFunction,
	#instVars : [
		'hasArguments'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #associating }
SYMLFunction >> -> returnTypeValue [
	<compileTime>
	<lazy>
	returnType ifNotNil: [ 
		self error: 'Cannot override function {1} return type.' format: {self validName} at: returnTypeValue node
	].

	returnTypeValue value isType ifFalse: [
		self error: 'Expected a return type for function {1}.' format: {self validName} at: returnTypeValue node
	].

	hasArguments := true.
	returnType := returnTypeValue value.
	self functionType.
]

{ #category : #'as yet unclassified' }
SYMLFunction >> applyWithArguments: argumentNodes [
	<compileTime>
	<lazy>
	| evaluationEnvironment argumentName argumentType |
	
	hasArguments ifTrue: [ 
		self halt
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
			module: module;
			name: argumentName;
			type: argumentType value;
			definitionNode: arg;
			yourself
	].

]

{ #category : #converting }
SYMLFunction >> asSysmelCompileTimeFunction [
	^ SYMLInterpretedFunctionWrapper new function: self
]

{ #category : #definition }
SYMLFunction >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	bodyLazyValue type ~~ self compilationTarget apsgNodeType ifTrue: [
		self error: 'Expected an APSG node for the definition of the function {1}.' format: { self validName } at: bodyLazyValue node
	].

	body := bodyLazyValue value.
	bodyEnvironment := bodyLazyValue environment.
]

{ #category : #associating }
SYMLFunction >> buildFunctionType [
	| argumentTypes bindedArgumentTypes |
	returnType ifNil: [
		self error: 'Cannot build a function without a return type. You can use Void.'
	].

	bindedArgumentTypes := (arguments collect: #type).
	argumentTypes := bindedArgumentTypes.
	self receiverType isVoidType ifFalse: [
		argumentTypes := {receiverType} , argumentTypes.
	].
	
	functionType := self compilationTarget
		functionArguments: argumentTypes returnType: returnType
		callingConvention: callingConvention variadic: self isCVariadic.
	bindedFunctionType := self compilationTarget
		functionArguments: bindedArgumentTypes returnType: returnType
		callingConvention: callingConvention variadic: self isCVariadic.

]

{ #category : #'as yet unclassified' }
SYMLFunction >> externC [
	<compileTime>
	self addFlag: #'extern-c'
]

{ #category : #initialization }
SYMLFunction >> initialize [
	super initialize.
	hasArguments := false.
	arguments := #().
]

{ #category : #testing }
SYMLFunction >> isExternC [
	<compileTime>
	^ self hasFlag: #'extern-c'
]

{ #category : #'as yet unclassified' }
SYMLFunction >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [hasArguments not ]) ifTrue: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]
