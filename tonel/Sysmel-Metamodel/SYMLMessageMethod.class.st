Class {
	#name : #SYMLMessageMethod,
	#superclass : #SYMLAbstractFunction,
	#instVars : [
		'hasSelector'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #associating }
SYMLMessageMethod >> -> returnTypeValue [
	<compileTime>
	<lazy>
	returnType ifNotNil: [ 
		self error: 'Cannot override function {1} return type.' format: {self validName} at: returnTypeValue node
	].

	returnTypeValue value isType ifFalse: [
		self error: 'Expected a return type for function {1}.' format: {self validName} at: returnTypeValue node
	].

	returnType := returnTypeValue value.
]

{ #category : #'as yet unclassified' }
SYMLMessageMethod >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	| result analyzedMessage |
	analyzedMessage := message withAnalyzedReceiverAndArgumentsInEnvironment: environment.
	analyzedMessage arguments detect: [ :arg | arg isSysmelIncompleteValueInEnvironment: environment ] ifFound: [ 
		^ SYMLSendMessageMacro new
			messageMethod: self;
			semanticAnalyzeMessage: analyzedMessage inEnvironment: environment at: aPosition
	].
	
	result := self analyzeAndEvaluateMessage: analyzedMessage toReceiver: receiverValue inEnvironment: environment at: aPosition.
	^ result asAPSGNodeInEnvironment: environment at: aPosition
]

{ #category : #associating }
SYMLMessageMethod >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	bodyLazyValue type ~~ self compilationTarget apsgNodeType ifTrue: [
		self error: 'Expected an APSG node for the definition of the function {1}.' format: { self validName } at: bodyLazyValue node
	].

	self functionType.

	body := bodyLazyValue value.
	bodyEnvironment := bodyLazyValue environment.
]

{ #category : #associating }
SYMLMessageMethod >> buildFunctionType [
	| argumentTypes bindedArgumentTypes |
	returnType ifNil: [ returnType := self compilationTarget dynamicObjectType ].
	bindedArgumentTypes := arguments collect: #type.
	argumentTypes := bindedArgumentTypes.
	
	self receiverType isVoidType ifFalse: [
		argumentTypes := {receiverType} , argumentTypes.
	].
	
	functionType := self compilationTarget functionArguments: argumentTypes
		returnType: returnType callingConvention: #cdecl variadic: self isCVariadic.
	bindedFunctionType := self compilationTarget functionArguments: bindedArgumentTypes
		returnType: returnType callingConvention: #cdecl variadic: self isCVariadic.

]

{ #category : #initialization }
SYMLMessageMethod >> createArgumentFromTemplate: argumentNode inEnvironment: environment [
	| argumentName argumentType |
	argumentNode isMessageNode ifTrue: [
		argumentNode receiver ifNotNil: [
			self error: 'Expected a message without receiver for the argument name.' at: argumentNode
		].

		(argumentNode selector numArgs ~= 1 or: [ (argumentNode selector includes: $:) not ]) ifTrue: [
			self error: 'Expected an unary selector for the argument {1} name' format: { argumentNode selector printString } at: argumentNode
		].
	
		argumentName := argumentNode selector allButLast asSymbol.
		argumentType := argumentNode arguments first analyzeAndEvaluateInEnvironment: environment.
		argumentType value isType ifFalse: [ 
			self error: 'Expected a type for the argument {1}' format: { argumentNode selector printString } at: argumentNode arguments first
		].
		
		^ SYMLFunctionArgument new
			parent: self;
			name: argumentName;
			type: argumentType value;
			definitionNode: argumentNode;
			yourself
	].

	self halt
]

{ #category : #initialization }
SYMLMessageMethod >> initialize [
	super initialize.
	hasSelector := false
]

{ #category : #testing }
SYMLMessageMethod >> isExternC [
	^ false
]

{ #category : #testing }
SYMLMessageMethod >> isMessage [
	^ true
]

{ #category : #testing }
SYMLMessageMethod >> isMessageMethod [
	^ true
]

{ #category : #testing }
SYMLMessageMethod >> isMethod [
	^ true
]

{ #category : #accessing }
SYMLMessageMethod >> mangledName [
	| escapedName |
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		escapedName := name sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $M;
			print: escapedName size;
			nextPutAll: escapedName.
	]
]

{ #category : #'macro compilation' }
SYMLMessageMethod >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ SYMLSendMessageMacro new
		messageMethod: self;
		semanticAnalyzeMessage: message inEnvironment: environment at: aPosition

]

{ #category : #'as yet unclassified' }
SYMLMessageMethod >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	hasSelector ifFalse: [ 
		self setSelectorWithTemplate: message inEnvironment: environment at: aPosition.
		^ message receiver
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #initialization }
SYMLMessageMethod >> setSelectorWithTemplate: message inEnvironment: environment at: aPosition [
	self name: message selector.
	hasSelector := true.
	arguments := message arguments collect: [ :arg | self createArgumentFromTemplate: arg inEnvironment: environment ].
	
]
