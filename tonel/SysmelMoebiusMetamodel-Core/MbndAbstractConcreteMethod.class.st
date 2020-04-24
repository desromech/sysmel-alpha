Class {
	#name : #MbndAbstractConcreteMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'module',
		'declarationPosition',
		'definitionNode',
		'definitionScope',
		'analyzedBody',
		'arguments',
		'argumentsWithoutReceiver',
		'children',
		'specialSemantics',
		'computeShaderLocalSize'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #adding }
MbndAbstractConcreteMethod >> addChild: aChild [
	aChild parent: self.
	children add: aChild.
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> analyzedBody [
	^ analyzedBody
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> argumentNodes [
	^ definitionNode arguments
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> arguments [
	^ arguments
]

{ #category : #evaluation }
MbndAbstractConcreteMethod >> canBeEvaluatedInCompileTime [
	(definitionNode isNil and: [analyzedBody isNil]) ifTrue: [ ^ false ].
	self hasExternalVisibility ifTrue: [ ^ false ].
	(self hasPragmaNamed: #notInCompileTime) ifTrue: [ ^ false ].
	self ensureSemanticAnalysis.
	
	^ super canBeEvaluatedInCompileTime
]

{ #category : #testing }
MbndAbstractConcreteMethod >> classBindingLiteral [
	self flag: 'TODO: Support nested method'.
	^ parent globalBindingAssociation
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> computeShaderLocalSize [
	^ computeShaderLocalSize
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> computeShaderLocalSize: anObject [
	computeShaderLocalSize := anObject
]

{ #category : #evaluation }
MbndAbstractConcreteMethod >> constructEvaluationScopeWithReceiver: receiverValue arguments: argumentValues [
	| evaluationScope argumentDefinition receiverDefinition |
	evaluationScope := MbndFunctionEvaluationScope parent: definitionScope.
	evaluationScope := evaluationScope newReturnContextScope newLexicalScope.
	
	receiverType isVoidType ifFalse: [ 
		receiverDefinition := arguments first.
		receiverDefinition createStorageInFunctionActivationScope: evaluationScope withValue: receiverValue
	].
	
	argumentValues doWithIndex: [ :argumentValue :index |
		argumentDefinition := argumentsWithoutReceiver at: index.
		argumentDefinition createStorageInFunctionActivationScope: evaluationScope withValue: argumentValue
	].

	^ evaluationScope
]

{ #category : #'as yet unclassified' }
MbndAbstractConcreteMethod >> createDynamicMethodWrapper [
	| wrapper |
	self compilationTarget dynamicObjectType ifNil: [ ^ nil ].
	boundType canHaveDynamicMethodWrapper ifFalse: [ ^ nil ].
	
	wrapper := MbndDynamicMethodWrapper new
		module: self module;
		parent: parent;
		wrappedMethod: self;
		name: name;
		receiverType: receiverType asDynamicMethodWrapperReceiverType;
		boundType: boundType asDynamicMethodWrapperType;
		yourself.
	wrapper type: (wrapper boundType withExplicitReceiverType: wrapper receiverType).
	^ wrapper
]

{ #category : #'as yet unclassified' }
MbndAbstractConcreteMethod >> createExtraImplicitArgument: argumentName withType: argumentType [
	^ MbndAstArgumentDefinitionNode new
		position: definitionNode position;
		name: argumentName;
		valueType: argumentType;
		yourself
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> createSemanticAnalysisScope [
	| analysisScope |
	analysisScope := (MbndFunctionAnalysisScope parent: definitionScope)
		programEntity: self;
		yourself.
		
	analysisScope := analysisScope newLexicalScopeAt: definitionNode.
	arguments do: [ :arg |
		arg isMbndAnonymousSymbol ifFalse: [ 
			analysisScope addSymbol: arg name binding: arg.
			
			arg isFunctionReceiverArgumentVariable ifTrue: [
				| superArgument |
				superArgument := arg asSuperArgumentVariable.
				superArgument name isMbndAnonymousSymbol ifFalse: [ 
					analysisScope addSymbol: superArgument name binding: superArgument.
				].
			].
		].
	].

	self setupAnalysisScopeForSpecialSemantics: analysisScope.

	^ analysisScope
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> declarationPosition [
	^ declarationPosition
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> declarationPosition: anObject [
	declarationPosition := anObject
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> defineArgument: argumentNode [
	^ MbndFunctionArgumentVariable new
		definitionNode: argumentNode;
		parent: self;
		name: argumentNode name;
		valueType: ((argumentNode valueType asConcreteTypeForAnalysisOfFunction: self) withSpecialSemantics: specialSemantics);
		yourself
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> defineArguments [
	| usedNames selfArgument |
	selfArgument := #().
	receiverType isVoidType ifFalse: [
		selfArgument := { MbndFunctionReceiverArgumentVariable new
			definitionNode: (definitionNode ifNil: [declarationPosition]);
			parent: self;
			name: #self;
			valueType: (receiverType asConcreteTypeForAnalysisOfFunction: self);
			yourself
		}
	].
	
	usedNames := Set new.
	arguments := selfArgument , (self extraImplicitArguments , self argumentNodes
		collectWithIndex: [ :argument :index |
		argument name isMbndAnonymousSymbol ifFalse: [
			(usedNames includes: argument name) ifTrue: [ 
				self error: 'argument {1} has the same name that is used by a previously defined argument.' format: { argument name asPrettySymbolName } at: argument
			 ].
			usedNames add: argument name
		].
		self defineArgument: argument
	]).

	arguments doWithIndex: [ :arg :index |
		arg argumentIndex: index
	].

	argumentsWithoutReceiver := receiverType isVoidType
		ifTrue: [ arguments ]
		ifFalse: [ arguments allButFirst ].

]

{ #category : #'as yet unclassified' }
MbndAbstractConcreteMethod >> definitionBody [
	^ definitionNode ifNotNil: [definitionNode body]
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> definitionPosition [
	^ (definitionNode ifNil: [ declarationPosition ])
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> definitionScope [
	^ definitionScope
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> definitionScope: anObject [
	definitionScope := anObject
]

{ #category : #serialization }
MbndAbstractConcreteMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#module . module encodeGraphForMessagePackWith: graphEncoder.
		#specialSemantics . specialSemantics.
		#computeShaderLocalSize . computeShaderLocalSize encodeGraphForMessagePackWith: graphEncoder.
	},  ((self needsDefinitionSerializedWith: graphEncoder) ifTrue: [ {
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#argumentsWithoutReceiver . argumentsWithoutReceiver encodeGraphForMessagePackWith: graphEncoder.
		#definitionScope . definitionScope encodeGraphForMessagePackWith: graphEncoder.
		#analyzedBody . analyzedBody encodeGraphForMessagePackWith: graphEncoder.
		#children . children encodeGraphForMessagePackWith: graphEncoder.
	}] ifFalse: [ #() ])
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> ensureSemanticAnalysis [
	| analyzer analysisScope |
	definitionNode ifNil: [ ^ self ].
	analyzedBody ifNotNil: [ ^ self ].
	
	(self returnType isNotNil and: [ self returnType isNonMoveable ]) ifTrue: [
		self error: 'Non-moveable type {1} is not allowed as a function return types.' format: {self returnType asString } at: self definitionPosition
	].

	self defineArguments.
	self getNonLocalReturnTarget.
	analysisScope := self createSemanticAnalysisScope.

	"Analyze the function body."	
	analyzer := MbndAstSemanticAnalyzer new 
		module: self module;
		scope: analysisScope;
		yourself.
		
	"The initial setup is to avoid infinite recursion."
	analyzedBody := self preprocessDefinitionBody: self definitionBody.
	analyzedBody := MbndProfiler component: #methodAnalysis with: [analyzer visitNode: analyzedBody].

	"Cast the result into the required return type."
	self returnType ifNil: [
		self applyInferredReturnType: (analyzedBody type inferValueTypeForNode: analyzedBody inScope: analysisScope) at: analyzedBody.
	].

	self returnType isVoidType ifFalse: [ 
		analyzedBody type isReturnType ifFalse: [
			analyzedBody := analyzer addImplicitCastFor: analyzedBody to: self returnType
		].
	].

]

{ #category : #evaluation }
MbndAbstractConcreteMethod >> evaluateApplicationWithReceiver: receiverValue arguments: argumentValues withEvaluator: evaluator at: node [
	^ self evaluateWithReceiver: receiverValue arguments: argumentValues withEvaluator: evaluator at: node
]

{ #category : #evaluation }
MbndAbstractConcreteMethod >> evaluateWithReceiver: receiverValue arguments: argumentValues at: position [
	| evaluator |
	evaluator := MbndAstEvaluator new module: self module.
	^ self evaluateWithReceiver: receiverValue arguments: argumentValues withEvaluator: evaluator at: position
]

{ #category : #evaluation }
MbndAbstractConcreteMethod >> evaluateWithReceiver: receiverValue arguments: argumentValues withEvaluator: evaluator at: position [
	| evaluationScope callEvaluator |
	(definitionNode isNil and: [ analyzedBody isNil]) ifTrue: [
		self error: 'Cannot evaluate in compile time external function/method {1}.'
			format: {name asPrettySymbolName} at: position
	].

	self ensureSemanticAnalysis.
	self assert: receiverType isVoidType = receiverValue isNil.
	self assert: argumentValues size = argumentsWithoutReceiver size.
	
	self pragmaAt: #intrinsic: ifPresent: [ :intrinsic |
		self halt
	].

	self canBeEvaluatedInCompileTime ifFalse: [
		self errorNotInCompileTime: 'Cannot evaluate method {1} in compile time.' format: { name asPrettySymbolName } at: position.
	].

	evaluationScope := self constructEvaluationScopeWithReceiver: receiverValue arguments: argumentValues.
	callEvaluator := MbndAstEvaluator new
		module: evaluator module;
		scope: evaluationScope.

	^ callEvaluator evaluateFunctionContent: analyzedBody.
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> extraImplicitArguments [
	^ #()
]

{ #category : #testing }
MbndAbstractConcreteMethod >> hasPragmaNamed: pragmaName [
	self definitionBody ifNotNil: [:body |
		^ body pragmaAt: pragmaName ifAbsent: [false] ifPresent: [:f | true]
	].

	^ super hasPragmaNamed: pragmaName
]

{ #category : #initialization }
MbndAbstractConcreteMethod >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #testing }
MbndAbstractConcreteMethod >> isAccessedByReference [
	^ self hasFlag: #ref
]

{ #category : #testing }
MbndAbstractConcreteMethod >> isConcreteMethod [
	^ true
]

{ #category : #testing }
MbndAbstractConcreteMethod >> isDefinition [
	^ definitionNode isNotNil or: [ self isAbstractVirtualMethod ]
]

{ #category : #testing }
MbndAbstractConcreteMethod >> isForwardingValue [
	^ self hasFlag: #tempRef
]

{ #category : #'as yet unclassified' }
MbndAbstractConcreteMethod >> lookupBoundReceiverSymbol: aSymbol [
	receiverType isVoidType ifFalse: [ 
		(receiverType withoutReferences withoutDecorations lookupSymbol: aSymbol) ifNotNil: [ :receiverSymbol |
			^ receiverSymbol asSymbolBoundWithReceiverBinding: arguments first
		].
	].
	
	^ nil
]

{ #category : #serialization }
MbndAbstractConcreteMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	module := encodedFields at: #module.
	arguments := encodedFields at: #arguments ifAbsent: [nil].
	argumentsWithoutReceiver := encodedFields at: #argumentsWithoutReceiver ifAbsent: [nil].
	specialSemantics := encodedFields at: #specialSemantics ifAbsent: [nil].
	computeShaderLocalSize := encodedFields at: #computeShaderLocalSize ifAbsent: [nil].

	definitionScope := encodedFields at: #definitionScope ifAbsent: [nil].
	analyzedBody := encodedFields at: #analyzedBody ifAbsent: [nil].

	declarationPosition := graphDecoder moduleLocation.
	children := encodedFields at: #children ifAbsent: [nil].
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> module [
	^ module
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> module: aModule [
	module := aModule
]

{ #category : #testing }
MbndAbstractConcreteMethod >> mustBeAvailableInTheGPU [
	^ specialSemantics isNotNil or: [super mustBeAvailableInTheGPU]
]

{ #category : #testing }
MbndAbstractConcreteMethod >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	definitionNode ifNil: [ ^ absentBlock value ].
	self ensureSemanticAnalysis.
	^ self analyzedBody pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> preprocessDefinitionBody: node [
	(node isLexicalScopeNode and: [ node expression isReturnStatementNode ]) ifTrue: [ ^ node ].
	
	"Wrap the node in a implicit return statement node."
	^ (MbndAstReturnStatementNode new
		position: node;
		implicitReturn: true;
		expression: node) lexicallyScoped
]

{ #category : #testing }
MbndAbstractConcreteMethod >> requiresCompiledMethodMetadata [
	self module hasGarbageCollectionSupport ifFalse: [ ^ false ].
	(parent isMbndType and: [parent isGarbageCollectedType]) ifTrue: [ ^ true ].
	(parent isAbstractSpecificMethod and: [parent requiresCompiledMethodMetadata]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
MbndAbstractConcreteMethod >> selectorRequiredLiteral [
	self flag: 'Create the MethodAdditionalState for the pragmas'.
	^ self typedSelector
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> setupAnalysisScopeForComputeShader: analysisScope [
	| localSizeLiteralValue localSizeVectorValue |
	localSizeLiteralValue := definitionNode body pragmaAt: #localSize: ifAbsent: [ #(1 1 1) ] ifPresent: [ :localSize |
		| localSizeValue pragmaValue |
		pragmaValue := localSize arguments first.
		pragmaValue isLiteralValueNode ifFalse: [
			self error: 'Local size pragma argument must be a literal value.' at: localSize arguments first
		].
	
		localSizeValue := localSize arguments first value.
		localSizeValue isArray ifTrue: [
			localSizeValue size > 3 ifTrue: [ 
				self error: 'Local size can have up to 3 dimensions.' at: pragmaValue
			].
			localSizeValue , ((Array new: 3 - localSizeValue size) atAllPut: 1)
		] ifFalse: [
			{ localSizeValue .  1 . 1}
		]
	].

	self assert: localSizeLiteralValue isArray.
	self assert: localSizeLiteralValue size = 3.
	self assert: (localSizeLiteralValue noneSatisfy: [:v | v isInteger not]).
	computeShaderLocalSize := localSizeLiteralValue.
	
	localSizeVectorValue := (self compilationTarget uint32x3Type defaultValueAt: definitionNode)
		slots: localSizeLiteralValue;
		yourself.
		
	analysisScope addSymbol: #localSize binding: localSizeVectorValue ifPresent: [:existent |
		self error: 'Compiler provided symbol #localSize overrides an user specified symbol.' at: definitionNode
	].
]

{ #category : #'semantic analysis' }
MbndAbstractConcreteMethod >> setupAnalysisScopeForSpecialSemantics: analysisScope [
	self specialSemantics = #compute ifTrue: [
		self setupAnalysisScopeForComputeShader: analysisScope
	].
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> shaderEntryPointInfoReferenceNodeAt: node [
	specialSemantics ifNil: [ self error: 'Function or method {1} is not a shader.' format: { name asPrettySymbolName } at: node ].
	^ MbndAstShaderEntryPointInfoReference new 
		position: node;
		binding: self;
		type: self compilationTarget shaderEntryPointInfo const ref;
		yourself
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> specialSemantics [
	^ specialSemantics
]

{ #category : #accessing }
MbndAbstractConcreteMethod >> specialSemantics: anObject [
	specialSemantics := anObject
]
