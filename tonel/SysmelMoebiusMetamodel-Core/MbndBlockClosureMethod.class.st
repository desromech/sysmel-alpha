Class {
	#name : #MbndBlockClosureMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'definitionPosition',
		'analyzedNode',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndBlockClosureMethod >> accept: aVisitor [
	^ aVisitor visitBlockClosureMethod: self
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

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> createSemanticAnalysisScopeWithParent: parentScope [
	| blockClosureScope analysisScope |
	blockClosureScope := MbndBlockClosureScope parent: parentScope.
	blockClosureScope programEntity: self.
	analysisScope := blockClosureScope newLexicalScope.
	
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
		valueType: argumentNode valueType;
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
MbndBlockClosureMethod >> isBlockClosureWithImmediateActivation [
	^ self hasFlag: #hasImmediateActivation
]

{ #category : #'as yet unclassified' }
MbndBlockClosureMethod >> makeBlockClosureWithImmediateActivation [
	^ self addFlag: #hasImmediateActivation
]

{ #category : #accessing }
MbndBlockClosureMethod >> type [
	^ type
]

{ #category : #accessing }
MbndBlockClosureMethod >> type: aType [
	type := aType
]