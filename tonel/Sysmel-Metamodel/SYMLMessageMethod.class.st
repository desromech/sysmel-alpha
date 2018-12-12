Class {
	#name : #SYMLMessageMethod,
	#superclass : #SYMLAbstractFunction,
	#traits : 'TSYMLMessageMethod',
	#classTraits : 'TSYMLMessageMethod classTrait',
	#instVars : [
		'hasSelector',
		'messageSendSelector'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #associating }
SYMLMessageMethod >> => returnTypeValue [
	<compileTime>
	<lazy>
	returnType ifNotNil: [ 
		self error: 'Cannot override function {1} return type.' format: {self validName} at: returnTypeValue node
	].

	returnTypeValue value isType ifFalse: [
		self error: 'Expected a return type for function {1}.' format: {self validName} at: returnTypeValue node
	].

	returnType := returnTypeValue value asVariableValueType.
]

{ #category : #'as yet unclassified' }
SYMLMessageMethod >> abstractFunctionKind [
	^ #message
]

{ #category : #'as yet unclassified' }
SYMLMessageMethod >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	| result analyzedMessage hasIncompleteArgument |
	analyzedMessage := message withAnalyzedReceiverAndArgumentsInEnvironment: environment.
	hasIncompleteArgument := analyzedMessage arguments
		detect: [ :arg | arg isSysmelIncompleteValueInEnvironment: environment ] ifFound: [ true ] ifNone: [ false ].
	
	(self isCompileTime not or: [hasIncompleteArgument]) ifTrue: [
		^ SYMLSendMessageMacro new
			messageMethod: self;
			semanticAnalyzeMessage: analyzedMessage inEnvironment: environment at: aPosition
	].
	
	result := self analyzeAndEvaluateMessage: analyzedMessage toReceiver: receiverValue inEnvironment: environment at: aPosition.
	^ result asAPSGNodeInEnvironment: environment at: aPosition
]

{ #category : #associating }
SYMLMessageMethod >> buildFunctionType [
	| argumentTypes bindedArgumentTypes |
	returnType ifNil: [returnType := self compilationTarget dynamicObjectType ].
	returnType ifNil: [ self error: 'Return type is required.' at: definitionPosition ].
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

{ #category : #accessing }
SYMLMessageMethod >> createMessageSendSelector [
	| concreteFunctionType |
	concreteFunctionType := functionType asConcreteTypeForFunctionAnalysis.
	concreteFunctionType isDynamicMessageFunctionType ifTrue: [ 
		self halt.
		^ name asSymbol
	] ifFalse: [
		^ (ByteString streamContents: [ :out |
			out nextPutAll: name.
			concreteFunctionType writeTypedSelectorDataInto: out omitReceiver: self receiverType isVoidType not
		]) asSymbol
	].


]

{ #category : #initialization }
SYMLMessageMethod >> defaultTypeForArgument: node inEnvironment: environment [
	self error: 'Explicit type for argument is required.' at: node
]

{ #category : #associating }
SYMLMessageMethod >> definition: bodyLazyValue [
	<compileTime>
	<lazy>
	
	| bodyValue |
	bodyValue := bodyLazyValue asAPSGNodeValueWithError: 
		('Expected an APSG node for the definition of the function {1}.' format: { self validName }).

	self functionType.

	body := bodyValue.
	bodyEnvironment := bodyLazyValue environment.
]

{ #category : #'code generation' }
SYMLMessageMethod >> generateSSAMessageSend: messageNode withReceiver: receiverValue arguments: argumentValues withBuilder: builder [
	^ self generateSSACallWithReceiver: receiverValue arguments: argumentValues withBuilder: builder at: messageNode
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

{ #category : #accessing }
SYMLMessageMethod >> messageSendSelector [
	^ messageSendSelector ifNil: [messageSendSelector := self createMessageSendSelector]
]

{ #category : #'macro compilation' }
SYMLMessageMethod >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	^ SYMLSendMessageMacro new
		messageMethod: self;
		semanticAnalyzeMessage: message inEnvironment: environment at: aPosition

]

{ #category : #'as yet unclassified' }
SYMLMessageMethod >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(definitionNode isNil and: [ definitionEnvironment isNil ]) ifTrue: [ 
		self
			definitionEnvironment: environment;
			definitionNode: message
	].

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
	self isTemplateFunctionInstance ifFalse: [
		parent addMacroMethodPattern: self withSelector: aNewName
	]
]
