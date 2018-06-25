Class {
	#name : #SYMLMessageMethod,
	#superclass : #SYMLAbstractFunction,
	#traits : 'TSYMLMessageMethod',
	#classTraits : 'TSYMLMessageMethod classTrait',
	#instVars : [
		'hasSelector'
	],
	#category : #'Sysmel-Metamodel-Function'
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
SYMLMessageMethod >> abstractFunctionKind [
	^ #message
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
	
	bodyLazyValue type isAPSGNodeType ifFalse: [
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
	name ifNotNil: [ self tryToAddToParentWithName: name ]

]

{ #category : #initialization }
SYMLMessageMethod >> defaultTypeForArgument: node inEnvironment: environment [
	self error: 'Explicit type for argument is required.' at: node
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
SYMLMessageMethod >> isMessageMethod [
	^ true
]

{ #category : #testing }
SYMLMessageMethod >> isMethod [
	^ true
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
	arguments := message arguments collect: [ :arg | self createArgumentFromTemplate: arg inEnvironment: environment ].
	self name: message selector.
	hasSelector := true.
	
]

{ #category : #accessing }
SYMLMessageMethod >> tryToAddToParentWithName: aNewName [
	functionType ifNil: [ ^ self ].
	parent addMacroMethodPattern: self withSelector: aNewName
]
