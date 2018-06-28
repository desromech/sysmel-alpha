Class {
	#name : #SYMLAbstractFunction,
	#superclass : #SYMLAbstractFunctionOrMacro,
	#instVars : [
		'returnType',
		'body',
		'bodyEnvironment',
		'analyzedBody',
		'arguments',
		'functionType',
		'callingConvention',
		'receiverType',
		'receiver',
		'locals',
		'ssaValue',
		'bindedFunctionType',
		'generator',
		'evaluator'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> CVariadic [
	<compileTime>
	self addFlag: #cvariadic
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> abstractFunctionKind [
	self subclassResponsibility
]

{ #category : #adding }
SYMLAbstractFunction >> addLocal: aLocalVariable [
	locals add: aLocalVariable
]

{ #category : #adding }
SYMLAbstractFunction >> addToPatternGroup: patternGroup [
	patternGroup addPatternAlternative: self withFunctionType: self functionType
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> addedToAbstractType: anAbstractType [
	receiverType := anAbstractType asReceiverType.
	receiver := SYMLFunctionReceiver new 
		name: #self;
		parent: self;
		module: module;
		type: receiverType;
		definitionPosition: definitionPosition;
		yourself.
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ identifier copyWithBinding: self andType: self type
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> analyzeAndEvaluateMessage: message toReceiver: aReceiver inEnvironment: environment at: aPosition [
	self analyzedBody.
	^ self evaluateWithReceiver: aReceiver arguments: (message arguments collect: [:arg | arg analyzeAndEvaluateInEnvironment: environment]) inEnvironment: environment at: aPosition

]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	self halt
]

{ #category : #accessing }
SYMLAbstractFunction >> analyzedBody [
	| analysisScope |
	analyzedBody ifNotNil: [ ^ analyzedBody ].
	body ifNil: [ self error: 'Cannot call function without a body.' ].
	analysisScope := self createAnalysisScope.
	analyzedBody := body semanticAnalysisInEnvironment: analysisScope.
	^ analyzedBody
]

{ #category : #accessing }
SYMLAbstractFunction >> bindedFunctionType [
	bindedFunctionType ifNil: [ self buildFunctionType ].
	^ bindedFunctionType
]

{ #category : #accessing }
SYMLAbstractFunction >> createAnalysisScope [
	| analysisScope |
	analysisScope := (SYMLFunctionAnalysisScope parent: bodyEnvironment)
		function: self;
		receiver: self receiver;
		yourself.
	receiver ifNotNil: [ 
		analysisScope addSymbol: receiver name value: receiver
	].
	arguments do: [ :arg |
		analysisScope addSymbol: arg name value: arg
	].

	^ analysisScope
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> createReceiverTypeForParent [
	parent isType ifFalse: [ ^ self ].
	receiverType := parent asReceiverType.
	receiver := SYMLFunctionReceiver new 
		name: #self;
		parent: self;
		module: module;
		type: receiverType;
		definitionPosition: definitionPosition;
		yourself.
]

{ #category : #'code generation' }
SYMLAbstractFunction >> createSSAValue [
	| argumentsOffset ssaArgument receiverOffset |
	ssaValue := SLVMFunction module: self module ssaModule name: self mangledName functionType: functionType ssaType.
	ssaValue unmangledName: self fullUnmangledName.
	body ifNil: [
		ssaValue makeExternal
	] ifNotNil: [
		bodyEnvironment isTemplateInstance ifTrue: [
			ssaValue makeLinkOnceODR
		].
	].
	
	self module isEmittingDebugInformation ifTrue: [
		self properDefinitionPosition ifNotNil: [ :position |
			ssaValue debugSourceLocation: (self module convertDebugPosition: position).
		]
	].

	receiverOffset := self returnType isReturnedThroughFirstArgument ifTrue: [1] ifFalse: [0].
	
	argumentsOffset := receiverOffset + (self receiverType isVoidType ifTrue: [0] ifFalse: [1]).
	argumentsOffset > 0 ifTrue: [ 
		(ssaValue arguments at: receiverOffset + 1) name: #receiver
	].

	arguments doWithIndex: [ :arg :index |
		ssaArgument := ssaValue arguments at: index + argumentsOffset..
		ssaArgument name: arg name
	].

	self decorateSSAValue: ssaValue.

	self module addPendingSSACodeGeneration: self
]

{ #category : #'code generation' }
SYMLAbstractFunction >> decorateSSAValue: functionSSAValue [
]

{ #category : #accessing }
SYMLAbstractFunction >> definition: bodyLazyValue [
	<compileTime>
	<lazy>
	^ self assignValue: bodyLazyValue
]

{ #category : #'semantic analysis' }
SYMLAbstractFunction >> ensureSemanticAnalysis [
	analyzedBody ifNotNil: [ ^ self ].
	self module addPendingSemanticAnalysis: self
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition [
	| activationScope result hasResult providedArgument convertedArgument convertedArguments |
	evaluator ifNotNil: [ 
		convertedArguments := arguments collectWithIndex: [:expectedArgument :index |
			providedArgument := activationArguments at: index.
			providedArgument coercedIntoType: expectedArgument type at: aPosition.
		].
		^ evaluator cull: aReceiver cull: convertedArguments cull: environment cull: aPosition
	].
	self analyzedBody.
	
	activationScope := SYMLFunctionActivationScope parent: bodyEnvironment.
	activationScope function: self.
	
	receiver ifNotNil: [ 
		activationScope addSymbol: receiver name value: (aReceiver asSysmelValueInEnvironment: environment)
	].

	(arguments size ~= activationArguments size and: [ self isCVariadic not or: [ activationArguments size < arguments size ] ]) ifTrue: [ 
		self error: 'Mismatching number of arguments.' at: aPosition
	].

	arguments doWithIndex: [:expectedArgument :index |
		providedArgument := activationArguments at: index.
		convertedArgument := providedArgument coercedIntoType: expectedArgument type at: aPosition.
		activationScope addSymbol: expectedArgument name value: convertedArgument.
	].
	
	result := nil.
	hasResult := false.
	[ 
		analyzedBody evaluateInEnvironment: activationScope
	] on: SYMLValueReturnException do: [ :exception |
		hasResult := true.
		result := exception value
	].

	(hasResult not and: [ returnType ~~ self compilationTarget voidType ]) ifTrue: [ 
		self error: 'Compile time called function {1} did not return a required value.' format: {self validName printString} at: aPosition
	].

	^ result
]

{ #category : #accessing }
SYMLAbstractFunction >> evaluator: anEvaluator [
	<compileTime>
	evaluator := anEvaluator asSysmelCompileTimeFunction
]

{ #category : #'code generation' }
SYMLAbstractFunction >> fetchCalledMethodValueForReceiver: receiverValue withBuilder: builder [
	self flag: 'TODO: Support virtual/looked up calls.'.
	^ self ssaValue
]

{ #category : #accessing }
SYMLAbstractFunction >> functionBodyEnvironment [
	^ bodyEnvironment
]

{ #category : #accessing }
SYMLAbstractFunction >> functionType [
	functionType ifNil: [ self buildFunctionType ].
	^ functionType
]

{ #category : #'code generation' }
SYMLAbstractFunction >> generateSSACallWithReceiver: receiverValue arguments: argumentValues withBuilder: builder at: position [
	| allArguments calledMethodValue |
	generator ifNotNil: [ 
		self halt.
	].

	self intrinsic ifNotNil: [ :intrinsic |
		^ intrinsic generateSSACallWithReceiver: receiverValue arguments: argumentValues withBuilder: builder at: position
	].

	allArguments := arguments.
	receiverValue ifNotNil: [ allArguments := {receiverValue} , argumentValues ].
	
	calledMethodValue := self fetchCalledMethodValueForReceiver: receiverValue withBuilder: builder.
	^ builder call: calledMethodValue arguments: allArguments
]

{ #category : #'code generation' }
SYMLAbstractFunction >> generateSSACode [
	| allocaBuilder builder bodyBlock argumentsOffset receiverOffset |
	body ifNil: [
		^ self
	].
	
	self ssaValue isNotEmpty ifTrue: [ ^ self ].

	"Create a builder for the allocas and another for the function body."
	allocaBuilder := SYMLSLVMBuilder on: self ssaValue.
	allocaBuilder sysmelModule: self module.
	allocaBuilder newBasicBlockHere: #entry.
	
	builder := SYMLSLVMBuilder on: self ssaValue.
	builder sysmelModule: self module.
	builder allocaBuilder: allocaBuilder.
	bodyBlock := builder newBasicBlockHere: #body.

	"Set the receiver"
	receiverOffset := self returnType isReturnedThroughFirstArgument ifTrue: [1] ifFalse: [0].
	argumentsOffset := receiverOffset.
	self receiverType isVoidType ifFalse: [ 
		receiver ssaValue: (self ssaValue arguments at: receiverOffset + 1).
		receiver setupSSADebugInformationWith: builder.
		argumentsOffset := receiverOffset + 1.
	].

	"Set the arguments"
	arguments doWithIndex: [ :arg :index |
		arg ssaValue: (self ssaValue arguments at: index + argumentsOffset).
		arg setupSSADebugInformationWith: builder
	].

	"Generate the local variables"
	locals do: [ :local | local generateSSALocalWithBuilder: builder ].
	
	"Generate the function body"
	analyzedBody generateSSACodeWith: builder.
	
	"Make sure we are returning something at the end."
	builder isLastTerminator ifFalse: [ 
		returnType isVoidType ifFalse: [ 
			self error: 'Not all of the execution paths are returning something.' at: analyzedBody
		].
		builder returnVoid
	].
	
	allocaBuilder jump: bodyBlock.

]

{ #category : #'code generation' }
SYMLAbstractFunction >> generateSSAReferenceWith: builder [
	^ self ssaValue
]

{ #category : #accessing }
SYMLAbstractFunction >> generator: aGenerator [
	<compileTime>
	generator := aGenerator asSysmelCompileTimeFunction
]

{ #category : #initialization }
SYMLAbstractFunction >> initialize [
	super initialize.
	callingConvention := #cdecl.
	locals := OrderedCollection new.
	
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> intrinsic [
	^ self intrinsicName ifNotNil: [ :intrinsicName |
		SYMLIntrinsicFunction fromName: intrinsicName
	]
]

{ #category : #accessing }
SYMLAbstractFunction >> intrinsicName [
	^ self analyzedBody pragmaAt: #intrinsic: ifPresent: [ :pragma | pragma arguments first unwrapSysmelValue ]
]

{ #category : #testing }
SYMLAbstractFunction >> isAbstractFunction [
	^ true
]

{ #category : #testing }
SYMLAbstractFunction >> isCVariadic [
	<compileTime>
	^ self hasFlag: #'cvariadic'
]

{ #category : #testing }
SYMLAbstractFunction >> isMessageMethod [
	^ false
]

{ #category : #testing }
SYMLAbstractFunction >> isMethod [
	^ false
]

{ #category : #accessing }
SYMLAbstractFunction >> mangledName [
	| escapedName |
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		escapedName := self validName sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $F;
			print: escapedName size;
			nextPutAll: escapedName;
			nextPutAll: self functionType argumentsMangledName.
	]
]

{ #category : #accessing }
SYMLAbstractFunction >> manglingCharacter [
	^ $F
]

{ #category : #'code generation' }
SYMLAbstractFunction >> properDefinitionPosition [
	^ body ifNotNil: [ body position ]
]

{ #category : #accessing }
SYMLAbstractFunction >> receiver [
	<compileTime>
	^ receiver
]

{ #category : #accessing }
SYMLAbstractFunction >> receiverType [
	<compileTime>
	^ receiverType ifNil: [ self compilationTarget voidType ]
]

{ #category : #accessing }
SYMLAbstractFunction >> returnType [
	<compileTime>
	^ returnType
]

{ #category : #'semantic analysis' }
SYMLAbstractFunction >> semanticAnalysis [
	body ifNil: [ ^ self ].
	self analyzedBody
]

{ #category : #'macro compilation' }
SYMLAbstractFunction >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	self halt
]

{ #category : #'code generation' }
SYMLAbstractFunction >> ssaValue [
	self assert: (body isNil or: [analyzedBody isNotNil]).
	ssaValue ifNil: [ self createSSAValue ].
	^ ssaValue
]

{ #category : #accessing }
SYMLAbstractFunction >> type [
	^ self functionType ref
]
