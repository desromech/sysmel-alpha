Class {
	#name : #SYMLAbstractFunctionTemplate,
	#superclass : #SYMLAbstractFunctionOrMacro,
	#instVars : [
		'templateArguments',
		'arguments',
		'returnType',
		'bodyValue',
		'templateInstanceCache'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #associating }
SYMLAbstractFunctionTemplate >> -> returnTypeValue [
	<compileTime>
	<lazy>
	returnType ifNotNil: [ 
		self error: 'Cannot override function {1} return type.' format: {self validName} at: returnTypeValue node
	].

	returnType := returnTypeValue.
]

{ #category : #adding }
SYMLAbstractFunctionTemplate >> addToPatternGroup: patternGroup [
	patternGroup addTemplatePatternAlternative: self
]

{ #category : #definition }
SYMLAbstractFunctionTemplate >> assignValue: bodyLazyValue [
	<compileTime>
	<lazy>
	
	^ self definition: bodyLazyValue
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionTemplate >> createArgumentParseEnvironmentFor: environment [
	| argumentParseEnvironment |
	argumentParseEnvironment := SYMLLexicalScope parent: environment.
	templateArguments do: [ :arg |
		argumentParseEnvironment addLocalVariable: arg at: arg definitionPosition
	].
	^ argumentParseEnvironment
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionTemplate >> createInstanceEnvironmentForArguments: instanceArguments [
	| instanceEnvironment |
	instanceEnvironment := SYMLLexicalScope parent: definitionEnvironment.
	templateArguments doWithIndex: [ :arg :index|
		instanceEnvironment symbol: arg name ifPresent: [ :existent |
			self error: 'Duplicated template argument name.'
		] ifAbsentPut: [ instanceArguments at: index]
	].
	^ instanceEnvironment
]

{ #category : #definition }
SYMLAbstractFunctionTemplate >> definition: bodyLazyValue [
	<compileTime>
	<lazy>
	
	bodyValue := bodyLazyValue
]

{ #category : #initialization }
SYMLAbstractFunctionTemplate >> initialize [
	super initialize.
	
	templateInstanceCache := Dictionary new.
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionTemplate >> macroFunctionForPatternMatchingContext: patternMatchingContext [
	| instanceArguments instanceEnvironment instance |
	instanceArguments := patternMatchingContext matchedArguments.
	templateInstanceCache at: instanceArguments ifPresent: [ :existentInstance |
		self halt
	].

	instanceEnvironment := self createInstanceEnvironmentForArguments: instanceArguments.
	instance := self createInstanceWithEnvironment: instanceEnvironment.
	
	templateInstanceCache at: instanceArguments put: instance.
	^ instance
]

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionTemplate >> matchArgument: argumentIndex type: suppliedArgumentType node: suppliedArgumentNode withMatchingContext: argumentMatchingContext at: position [
	| expectedArgument matchedArgumentType coercionRule |
	expectedArgument := arguments at: argumentIndex.
	matchedArgumentType := expectedArgument matchValueOfType: suppliedArgumentType withMatchingContext: argumentMatchingContext at: position.
	matchedArgumentType ifNil: [ ^ -1 ].
	
	coercionRule := suppliedArgumentType node: suppliedArgumentNode coercedImplicitlyInto: matchedArgumentType.
	^ coercionRule coercionCost
]

{ #category : #'instance creation' }
SYMLAbstractFunctionTemplate >> newTemplateMatchingContext [
	^ SYMLPatternMatchingContext for: self
]

{ #category : #accessing }
SYMLAbstractFunctionTemplate >> requiredArgumentCount [
	^ arguments size
]

{ #category : #accessing }
SYMLAbstractFunctionTemplate >> templateArguments [
	^ templateArguments
]

{ #category : #accessing }
SYMLAbstractFunctionTemplate >> templateArguments: anObject [
	templateArguments := anObject
]
