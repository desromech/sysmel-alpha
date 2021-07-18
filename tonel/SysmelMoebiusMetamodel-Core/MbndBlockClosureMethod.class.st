Class {
	#name : #MbndBlockClosureMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'definitionPosition',
		'definitionScope',
		'analyzedNode',
		'arguments',
		'children',
		'capturedVariables',
		'capturedVariableMap',
		'lambdaIndex',
		'closureKind'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndBlockClosureMethod class >> messagePackTypeName [
	^ #BlockClosureMethod
]

{ #category : #visiting }
MbndBlockClosureMethod >> accept: aVisitor [
	^ aVisitor visitBlockClosureMethod: self
]

{ #category : #adding }
MbndBlockClosureMethod >> addChild: aChild [
	aChild parent: self.
	children add: aChild.
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> analyzeReferenceNode: referenceNode toCapturedVariable: capturedVariableOriginalDefinition with: analyzer [
	| capturedVariable |
	capturedVariable := self getOrCreateCapturedVariableDefinition: capturedVariableOriginalDefinition.
	^ MbndAstVariableReference new
		binding: capturedVariable;
		position: referenceNode;
		yourself
]

{ #category : #accessing }
MbndBlockClosureMethod >> analyzedBody [
	^ analyzedNode body
]

{ #category : #accessing }
MbndBlockClosureMethod >> analyzedNode [
	^ analyzedNode
]

{ #category : #accessing }
MbndBlockClosureMethod >> analyzedNode: anObject [
	analyzedNode := anObject
]

{ #category : #accessing }
MbndBlockClosureMethod >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndBlockClosureMethod >> capturedVariables [
	^ capturedVariables
]

{ #category : #testing }
MbndBlockClosureMethod >> classBindingLiteral [
	^ parent classBindingLiteral
]

{ #category : #accessing }
MbndBlockClosureMethod >> closureKind [
	^ closureKind
]

{ #category : #accessing }
MbndBlockClosureMethod >> closureKind: anObject [
	closureKind := anObject
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> constructEvaluationScopeWithArguments: argumentValues capturedValues: capturedValues [
	| evaluationScope argumentDefinition |
	evaluationScope := MbndFunctionEvaluationScope parent: definitionScope.
	evaluationScope := evaluationScope newReturnContextScope newLexicalScope.

	argumentValues doWithIndex: [ :argumentValue :index |
		argumentDefinition := arguments at: index.
		argumentDefinition createStorageInFunctionActivationScope: evaluationScope withValue: argumentValue
	].

	capturedValues doWithIndex: [ :value |
		self halt
	].

	^ evaluationScope
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> createSemanticAnalysisScopeWithParent: parentScope [
	| blockClosureScope analysisScope |
	blockClosureScope := MbndBlockClosureScope parent: parentScope.
	blockClosureScope programEntity: self.
	analysisScope := blockClosureScope newLexicalScopeAt: definitionPosition.
	
	arguments do: [ :arg |
		arg isMbndAnonymousSymbol ifFalse: [ 
			analysisScope addSymbol: arg name binding: arg
		]
	].
	
	^ analysisScope

]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> defineArgument: argumentNode [
	^ MbndFunctionArgumentVariable new
		definitionNode: argumentNode;
		parent: self;
		name: argumentNode name;
		valueType: (argumentNode valueType asConcreteTypeForAnalysisOfFunction: self);
		yourself
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> defineArguments [
	| usedNames |
	self assert: arguments isNil.
	usedNames := Set new.
	arguments := analyzedNode arguments collectWithIndex: [ :argument :index |
		argument name isMbndAnonymousSymbol ifFalse: [
			(usedNames includes: argument name) ifTrue: [ 
				self error: 'argument {1} has the same name that is used by a previously defined argument.' format: { argument name asPrettySymbolName } at: argument
			 ].
			usedNames add: argument name
		].
		self defineArgument: argument
	].

	arguments doWithIndex: [ :arg :index |
		arg argumentIndex: index
	].


]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionPosition: anObject [
	definitionPosition := anObject
]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionScope [
	^ definitionScope
]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionScope: anObject [
	definitionScope := anObject
]

{ #category : #serialization }
MbndBlockClosureMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#definitionScope . definitionScope encodeGraphForMessagePackWith: graphEncoder.
		#analyzedNode . analyzedNode encodeGraphForMessagePackWith: graphEncoder.
		#closureKind . closureKind encodeGraphForMessagePackWith: graphEncoder.
		#children . children encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> evaluateApplicationWithCapturedValues: capturedValues arguments: argumentValues withEvaluator: evaluator at: position [
	| evaluationScope callEvaluator |
	self analyzedBody ifNil: [
		self error: 'Cannot evaluate in compile time external block closure {1}.'
			format: {name asPrettySymbolName} at: position
	].

	self ensureSemanticAnalysis.
	self assert: argumentValues size = arguments size.
	
	self intrinsicName ifNotNil: [ :intrinsic |
		self halt
	].

	self canBeEvaluatedInCompileTime ifFalse: [
		self errorNotInCompileTime: 'Cannot evaluate method {1} in compile time.' format: { name asPrettySymbolName } at: position.
	].

	evaluationScope := self constructEvaluationScopeWithArguments: argumentValues capturedValues: capturedValues.
	callEvaluator := MbndAstEvaluator new
		module: evaluator module;
		scope: evaluationScope.

	^ callEvaluator evaluateFunctionContent: self analyzedBody.
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> extractCapturedValuesFromEvaluationScope: instantiationScope [
	^ (capturedVariables collect: [ :var | self halt ] ) as: Array
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> getNonLocalResultVariable [
	self isNonLocalReturnTargetEntity ifTrue: [ ^ super getNonLocalReturnTarget ].
	^ nonLocalResultVariable ifNil: [ nonLocalResultVariable := self getOrCreateCapturedVariableDefinition: parent getNonLocalResultVariable ]
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> getNonLocalReturnTarget [
	self isNonLocalReturnTargetEntity ifTrue: [ ^ super getNonLocalReturnTarget ].
	^ nonLocalReturnTarget ifNil: [ nonLocalReturnTarget := self getOrCreateCapturedVariableDefinition: parent getNonLocalReturnTarget ]
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> getOrCreateCapturedVariableDefinition: originalVariable [
	originalVariable parent == self ifTrue: [ ^ super getOrCreateCapturedVariableDefinition: originalVariable ].
	^ capturedVariableMap at: originalVariable ifAbsentPut: [ 
		| parentVar capturedVariable |
		parentVar := parent getOrCreateCapturedVariableDefinition: originalVariable.
		capturedVariable := MbndFunctionCapturedVariable new
			name: parentVar name;
			upperContextVariable: parentVar;
			yourself.
		parentVar addImmediateCapture: capturedVariable.
		self addChild: capturedVariable.
		capturedVariables add: capturedVariable.
		capturedVariable
	].
]

{ #category : #'semantic analysis' }
MbndBlockClosureMethod >> hasExplicitReturnStatement [
	^ self analyzedBody expression expression type isReturnType
]

{ #category : #adding }
MbndBlockClosureMethod >> initialize [
	super initialize.
	children := OrderedCollection new.
	capturedVariables := OrderedCollection new.
	capturedVariableMap := IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> isBlockClosureMethod [
	^ true
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> isBlockClosureWithImmediateActivation [
	^ self hasFlag: #hasImmediateActivation
]

{ #category : #testing }
MbndBlockClosureMethod >> isNonLocalReturnTargetEntity [
	^ self hasFlag: #nonLocalReturnTarget
]

{ #category : #accessing }
MbndBlockClosureMethod >> lambdaIndex [
	^ lambdaIndex
]

{ #category : #accessing }
MbndBlockClosureMethod >> lambdaIndex: anObject [
	lambdaIndex := anObject.
	name := ('__lambda' , lambdaIndex asString) asSymbol
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> makeBlockClosureWithImmediateActivation [
	self addFlag: #hasImmediateActivation.
	self assert: self analyzedBody expression isReturnStatementNode.
	self analyzedBody expression isInImmediatelyActivatedClosure: true
]

{ #category : #serialization }
MbndBlockClosureMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	arguments := encodedFields at: #arguments ifAbsent: [nil].

	definitionScope := encodedFields at: #definitionScope ifAbsent: [nil].
	analyzedNode := encodedFields at: #analyzedNode ifAbsent: [nil].
	closureKind := encodedFields at: #closureKind ifAbsent: [nil].

	definitionPosition := graphDecoder moduleLocation.
	children := encodedFields at: #children ifAbsent: [nil].
]

{ #category : #testing }
MbndBlockClosureMethod >> selectorRequiredLiteral [
	^ nil
]

{ #category : #initialization }
MbndBlockClosureMethod >> setNonLocalReturnTarget: aBoolean [
	self setFlag: #nonLocalReturnTarget value: aBoolean
]

{ #category : #accessing }
MbndBlockClosureMethod >> type [
	^ type
]

{ #category : #accessing }
MbndBlockClosureMethod >> type: aType [
	type := aType
]
