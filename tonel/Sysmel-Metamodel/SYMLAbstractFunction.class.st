Class {
	#name : #SYMLAbstractFunction,
	#superclass : #SYMLNamedProgramEntity,
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
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> CVariadic [
	<compileTime>
	self addFlag: #cvariadic
]

{ #category : #adding }
SYMLAbstractFunction >> addLocal: aLocalVariable [
	locals add: aLocalVariable
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> addedToAbstractType: anAbstractType [
	receiverType := anAbstractType asReceiverType.
	receiver := SYMLFunctionReceiver new 
		name: #self;
		type: receiverType;
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
	| result |
	result := self analyzeAndEvaluateMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition.
	^ result asAPSGNodeInEnvironment: environment at: aPosition
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

{ #category : #'code generation' }
SYMLAbstractFunction >> createSSAValue [
	| argumentsOffset ssaArgument receiverOffset |
	ssaValue := SLVMFunction module: self module ssaModule name: self mangledName functionType: functionType ssaType.
	ssaValue unmangledName: name.
	
	receiverOffset := self returnType isReturnedThroughFirstArgument ifTrue: [1] ifFalse: [0].
	
	argumentsOffset := receiverOffset + (self receiverType isVoidType ifTrue: [0] ifFalse: [1]).
	argumentsOffset > 0 ifTrue: [ 
		(ssaValue arguments at: receiverOffset + 1) name: #receiver
	].

	arguments doWithIndex: [ :arg :index |
		ssaArgument := ssaValue arguments at: index + argumentsOffset..
		ssaArgument name: arg name
	].

]

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition [
	| activationScope result hasResult providedArgument convertedArgument |
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
SYMLAbstractFunction >> functionType [
	functionType ifNil: [ self buildFunctionType ].
	^ functionType
]

{ #category : #'code generation' }
SYMLAbstractFunction >> generateSSACode [
	| allocaBuilder builder bodyBlock argumentsOffset receiverOffset |
	body ifNil: [
		name ifNotNil: [
			self ssaValue makeExternal
		].
		^ self
	].
	
	"Set the receiver"
	receiverOffset := self returnType isReturnedThroughFirstArgument ifTrue: [1] ifFalse: [0].
	argumentsOffset := receiverOffset.
	self receiverType isVoidType ifFalse: [ 
		receiver ssaValue: (self ssaValue arguments at: receiverOffset + 1).
		argumentsOffset := receiverOffset + 1.
	].

	"Set the arguments"
	arguments doWithIndex: [ :arg :index |
		arg ssaValue: (self ssaValue arguments at: index + argumentsOffset)
	].

	"Create a builder for the allocas and another for the function body."
	allocaBuilder := SYMLSLVMBuilder on: self ssaValue.
	allocaBuilder newBasicBlockHere: #entry.
	
	builder := SYMLSLVMBuilder on: self ssaValue.
	builder allocaBuilder: allocaBuilder.
	bodyBlock := builder newBasicBlockHere: #body.
	
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

{ #category : #initialization }
SYMLAbstractFunction >> initialize [
	super initialize.
	callingConvention := #cdecl.
	locals := OrderedCollection new.
	
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

{ #category : #'as yet unclassified' }
SYMLAbstractFunction >> mangledName [
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			nextPut: $F;
			print: name size;
			nextPutAll: name.
	]
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
	ssaValue ifNil: [ self createSSAValue ].
	^ ssaValue
]

{ #category : #accessing }
SYMLAbstractFunction >> type [
	^ self functionType ref
]
