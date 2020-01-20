Class {
	#name : #MbndBlockClosureMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'definitionPosition',
		'analyzedNode',
		'arguments',
		'children',
		'needsGarbageCollection',
		'capturedVariables',
		'capturedVariableMap'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

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

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> computeGarbageCollectionNeed [
	needsGarbageCollection := boundType returnType isGarbageCollectedType.
	needsGarbageCollection ifTrue: [ ^ self ].

	boundType argumentTypes do: [ :arg |
		arg isGarbageCollectedType ifTrue: [ 
			needsGarbageCollection := true.
			^ self.
		].
	].

	capturedVariables do: [ :capturedVariable |
		capturedVariable type isGarbageCollectedType ifTrue: [ 
			needsGarbageCollection := true.
			^ self
		].
	].

	self flag: 'TODO: Check the captured variables.'
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

]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
MbndBlockClosureMethod >> definitionPosition: anObject [
	definitionPosition := anObject
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
		self addChild: capturedVariable.
		capturedVariables add: capturedVariable.
		capturedVariable
	].
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

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> makeBlockClosureWithImmediateActivation [
	self addFlag: #hasImmediateActivation.
	self assert: self analyzedBody expression isReturnStatementNode.
	self analyzedBody expression isInImmediatelyActivatedClosure: true
]

{ #category : #accessing }
MbndBlockClosureMethod >> needsGarbageCollection [
	needsGarbageCollection ifNil: [ self computeGarbageCollectionNeed ].
	^ needsGarbageCollection
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
