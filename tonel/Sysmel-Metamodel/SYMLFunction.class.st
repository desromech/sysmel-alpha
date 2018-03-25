Class {
	#name : #SYMLFunction,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'module',
		'name',
		'functionType',
		'argumentNames',
		'argumentNodes',
		'definition',
		'definitionEnvironment',
		'hasSemanticAnalysis',
		'ssaValue',
		'arguments',
		'locals'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #adding }
SYMLFunction >> addLocal: aLocalVariable [
	locals add: aLocalVariable.
	^ aLocalVariable
]

{ #category : #accessing }
SYMLFunction >> argumentNames [
	^ argumentNames
]

{ #category : #accessing }
SYMLFunction >> argumentNames: anObject [
	argumentNames := anObject
]

{ #category : #accessing }
SYMLFunction >> argumentNodes [
	^ argumentNodes
]

{ #category : #accessing }
SYMLFunction >> argumentNodes: anObject [
	argumentNodes := anObject
]

{ #category : #accessing }
SYMLFunction >> arguments [
	^ arguments
]

{ #category : #'object building' }
SYMLFunction >> createLocalVariableBinding: localVariableBuilder [
	^self addLocal: (SYMLFunctionLocalVariable new
		name: localVariableBuilder name;
		valueType: localVariableBuilder type;
		function: self;
		yourself)
]

{ #category : #'semantic analysis' }
SYMLFunction >> createSSAValue [
	ssaValue := SLVMFunction module: self module ssaModule name: self mangledName functionType: functionType ssaType.
	ssaValue unmangledName: name.
	
	ssaValue arguments doWithIndex: [ :arg :index |
		arg name: (argumentNames at: index)
	].

]

{ #category : #accessing }
SYMLFunction >> definition [
	^ definition
]

{ #category : #accessing }
SYMLFunction >> definition: anObject [
	definition := anObject
]

{ #category : #accessing }
SYMLFunction >> definitionEnvironment [
	^ definitionEnvironment
]

{ #category : #accessing }
SYMLFunction >> definitionEnvironment: anObject [
	definitionEnvironment := anObject
]

{ #category : #accessing }
SYMLFunction >> evaluateTypeAt: position [
	^ functionType const ref
]

{ #category : #accessing }
SYMLFunction >> functionType [
	^ functionType
]

{ #category : #accessing }
SYMLFunction >> functionType: anObject [
	functionType := anObject
]

{ #category : #'semantic analysis' }
SYMLFunction >> generateSSACode [
	| allocaBuilder builder returnType bodyBlock |
	definition ifNil: [
		name ifNotNil: [
			self ssaValue makeExternal
		].
		^ self
	].
	
	"Set the arguments"
	arguments doWithIndex: [ :arg :index |
		arg ssaValue: (self ssaValue arguments at: index)
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
	definition generateSSACodeWith: builder.
	
	"Make sure we are returning something at the end."
	builder isLastTerminator ifFalse: [ 
		returnType := functionType returnType.
		returnType isVoidType ifFalse: [ 
			self error: 'Not all of the execution paths are returning something.' at: definition
		].
		builder returnVoid
	].
	
	allocaBuilder jump: bodyBlock.

]

{ #category : #'meta evaluation' }
SYMLFunction >> generateSSAReferenceWith: builder [
	^ self ssaValue
]

{ #category : #initialization }
SYMLFunction >> initialize [
	super initialize.
	argumentNames := #().
	hasSemanticAnalysis := false.
	locals := OrderedCollection new.
]

{ #category : #testing }
SYMLFunction >> isExternC [
	^ self hasFlag: #externC
]

{ #category : #testing }
SYMLFunction >> isFunction [
	^ true
]

{ #category : #accessing }
SYMLFunction >> locals [
	^ locals
]

{ #category : #'semantic analysis' }
SYMLFunction >> mangledName [
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			print: name size;
			nextPutAll: name.
	]
]

{ #category : #accessing }
SYMLFunction >> module [
	^ module
]

{ #category : #accessing }
SYMLFunction >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLFunction >> name [
	^ name
]

{ #category : #accessing }
SYMLFunction >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLFunction >> returnType [
	^ functionType returnType
]

{ #category : #'semantic analysis' }
SYMLFunction >> semanticAnalysis [
	| scope argument |
	(definition isNil or: [hasSemanticAnalysis]) ifTrue: [ ^ self ].

	scope := (SYMLFunctionScope parent: definitionEnvironment) function: self.
	scope := SYMLLexicalScope parent: scope.
	
	arguments := functionType arguments collectWithIndex: [ :argumentType :index |
		argument := SYMLFunctionArgument new
			name: (argumentNames at: index);
			type: argumentType;
			node: (argumentNodes at: index);
			yourself.
		scope lookSymbol: argument name ifPresent: [:existent |
			self error: 'Duplicated argument name {1}.' format:  { argument name } at:  argument node
		] ifAbsentPut: [ argument ].
		argument
	].

	hasSemanticAnalysis := true.
	definition := definition semanticAnalysisInEnvironment: scope
]

{ #category : #'semantic analysis' }
SYMLFunction >> ssaValue [
	ssaValue ifNil: [ self createSSAValue ].
	^ ssaValue
]

{ #category : #accessing }
SYMLFunction >> type [
	^ functionType ref
]
