Class {
	#name : #SYMLMessageMethod,
	#superclass : #SYMLAbstractFunction,
	#instVars : [
		'hasSelector'
	],
	#category : #'Sysmel-Metamodel-Program'
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

{ #category : #associating }
SYMLMessageMethod >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	bodyLazyValue type ~~ self compilationTarget apsgNodeType ifTrue: [
		self error: 'Expected an APSG node for the definition of the function {1}.' format: { self validName } at: bodyLazyValue node
	].

	self buildFunctionType.

	body := bodyLazyValue value.
	bodyEnvironment := bodyLazyValue environment.
]

{ #category : #associating }
SYMLMessageMethod >> buildFunctionType [
	| argumentTypes |
	returnType ifNil: [ returnType := self compilationTarget dynamicObjectType ].
	argumentTypes := arguments collect: #type.
	
	functionType := self compilationTarget functionArguments: argumentTypes returnType: returnType callingConvention: #cdecl variadic: self isCVariadic.

]

{ #category : #initialization }
SYMLMessageMethod >> createArgumentFromTemplate: argumentNode inEnvironment: environment [
	self halt
]

{ #category : #initialization }
SYMLMessageMethod >> initialize [
	super initialize.
	hasSelector := false
]

{ #category : #testing }
SYMLMessageMethod >> isMethod [
	^ true
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
	self name: message selector.
	hasSelector := true.
	arguments := message arguments collect: [ :arg | self createArgumentFromTemplate: arg inEnvironment: environment ].
	
]
