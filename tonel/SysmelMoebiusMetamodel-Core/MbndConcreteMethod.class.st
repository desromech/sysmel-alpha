Class {
	#name : #MbndConcreteMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#instVars : [
		'declarationPosition',
		'definitionNode',
		'definitionScope',
		'analyzedBody',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #accessing }
MbndConcreteMethod >> analyzedBody [
	^ analyzedBody
]

{ #category : #'semantic analysis' }
MbndConcreteMethod >> createSemanticAnalysisScope [
	| analysisScope |
	analysisScope := (MbndFunctionAnalysisScope parent: definitionScope)
		programEntity: self;
		yourself.
		
	analysisScope := analysisScope newLexicalScope.
	arguments do: [ :arg |
		arg isMbndAnonymousSymbol ifFalse: [ 
			analysisScope addSymbol: arg name binding: arg
		]
	].

	^ analysisScope
]

{ #category : #accessing }
MbndConcreteMethod >> declarationPosition [
	^ declarationPosition
]

{ #category : #accessing }
MbndConcreteMethod >> declarationPosition: anObject [
	declarationPosition := anObject
]

{ #category : #'semantic analysis' }
MbndConcreteMethod >> defineArgument: argumentNode [
	^ MbndFunctionArgumentVariable new
		definitionNode: argumentNode;
		parent: self;
		name: argumentNode name;
		valueType: argumentNode valueType;
		yourself
]

{ #category : #'semantic analysis' }
MbndConcreteMethod >> defineArguments [
	| usedNames |
	receiverType isVoidType ifFalse: [
		self halt
	].
	
	usedNames := Set new.
	arguments := definitionNode arguments collectWithIndex: [ :argument :index |
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
MbndConcreteMethod >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
MbndConcreteMethod >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #accessing }
MbndConcreteMethod >> definitionScope [
	^ definitionScope
]

{ #category : #accessing }
MbndConcreteMethod >> definitionScope: anObject [
	definitionScope := anObject
]

{ #category : #'semantic analysis' }
MbndConcreteMethod >> enqueueDelayedSemanticAnalysis [
]

{ #category : #'semantic analysis' }
MbndConcreteMethod >> ensureSemanticAnalysis [
	| analyzer analysisScope |
	definitionNode ifNil: [ ^ self ].
	analyzedBody ifNotNil: [ ^ self ].
	
	self defineArguments.
	analysisScope := self createSemanticAnalysisScope.

	"Analyze the function body."	
	analyzer := MbndAstSemanticAnalyzer new 
		module: self module;
		scope: analysisScope;
		yourself.
	analyzedBody := analyzer visitNode: definitionNode body.

	"Cast the result into the required return type."
	self returnType isVoidType ifFalse: [ 
		analyzedBody type isReturnType ifFalse: [
			analyzedBody := analyzer addImplicitCastFor: analyzedBody to: self returnType
		].
	].

]