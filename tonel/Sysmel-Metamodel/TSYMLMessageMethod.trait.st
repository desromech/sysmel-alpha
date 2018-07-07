Trait {
	#name : #TSYMLMessageMethod,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'argument parsing' }
TSYMLMessageMethod >> createArgumentFromIdentifierTemplate: argumentNode inEnvironment: environment [
	^ SYMLFunctionArgument new
		parent: self;
		module: self module;
		name: argumentNode value;
		type: (self defaultTypeForArgument: argumentNode inEnvironment: environment);
		definitionNode: argumentNode;
		yourself
]

{ #category : #'argument parsing' }
TSYMLMessageMethod >> createArgumentFromMessageTemplate: argumentNode inEnvironment: environment [
	| argumentName argumentType |
	argumentNode receiver ifNotNil: [
		self error: 'Expected a message without receiver for the argument name.' at: argumentNode
	].

	(argumentNode selector numArgs ~= 1 or: [ (argumentNode selector includes: $:) not ]) ifTrue: [
		self error: 'Expected an unary selector for the argument {1} name' format: { argumentNode selector printString } at: argumentNode
	].
	
	argumentName := argumentNode selector allButLast asSymbol.
	argumentType := argumentNode arguments first analyzeAndEvaluateInEnvironment: environment.
	argumentType value isType ifFalse: [ 
		self error: 'Expected a type for the argument {1}' format: { argumentNode selector printString } at: argumentNode arguments first
	].
		
	^ SYMLFunctionArgument new
		parent: self;
		module: self module;
		name: argumentName;
		type: argumentType value asVariableValueType;
		definitionNode: argumentNode;
		yourself
]

{ #category : #'argument parsing' }
TSYMLMessageMethod >> createArgumentFromTemplate: argumentNode inEnvironment: environment [
	argumentNode isMessageNode ifTrue: [
		^ self createArgumentFromMessageTemplate: argumentNode inEnvironment: environment
	].

	argumentNode isIdentifierNode ifTrue: [ 
		^ self createArgumentFromIdentifierTemplate: argumentNode inEnvironment: environment
	].

	self error: 'Invalid message argument pattern.' at: argumentNode
]

{ #category : #'argument parsing' }
TSYMLMessageMethod >> defaultTypeForArgument: node inEnvironment: environment [
	self explicitRequirement
]
