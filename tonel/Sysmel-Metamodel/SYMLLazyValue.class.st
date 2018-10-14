Class {
	#name : #SYMLLazyValue,
	#superclass : #SYMLAbstractConcreteValue,
	#instVars : [
		'node',
		'environment',
		'isEvaluated',
		'cachedValue'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #converting }
SYMLLazyValue >> asAPSGNodeInEnvironment: newEnvironment at: aPosition [
	^ SYMLAPSGMetaObjectInstance new
			position: aPosition;
			metaObject: self;
			yourself
]

{ #category : #converting }
SYMLLazyValue >> asAPSGNodeValue [
	^ self asAPSGNodeValueWithError: 'Expected an apsg node.'

	
]

{ #category : #converting }
SYMLLazyValue >> asAPSGNodeValueWithError: errorMessage [
	^ self asAPSGNodeValueWithError: errorMessage at: node position
]

{ #category : #converting }
SYMLLazyValue >> asAPSGNodeValueWithError: errorMessage at: aPosition [
	self type isAPSGNodeType ifTrue: [ ^ self value ].
	self type cleanValueType isAPSGNodeType ifTrue: [
		self type isReferenceType ifTrue: [ 
			^ self value sysmelEvaluateReference
		] ifFalse: [
			"This could be a const"
			^ self value
		]
	].
	
	self error: errorMessage at: aPosition
]

{ #category : #converting }
SYMLLazyValue >> asBlockDictionaryValue [
	| evaluatedValue expectedNodeValue |
	node isSequenceNode ifTrue: [ ^ self ].
	(node isLexicalScopeNode and: [ node node isSequenceNode ]) ifTrue: [ 
	^ SYMLFunctionalValue new
		node: node node;
		environment: environment;
		yourself
	].
	
	evaluatedValue := self value.
	expectedNodeValue := self type isReferenceType ifTrue: [ evaluatedValue value sysmelEvaluateReference ] ifFalse: [ evaluatedValue value ].
	expectedNodeValue isSYMLAPSGNode ifFalse: [ 
		self error: 'Expected a sequence node, or a lexically scoped sequence node.' at: node position.
	].

	expectedNodeValue isLexicalScopeNode ifTrue: [ expectedNodeValue := expectedNodeValue node ].
	expectedNodeValue isSequenceNode ifFalse: [ 
		self error: 'Expected a sequence node, or a lexically scoped sequence node.' at: node position.
	].

	^ SYMLFunctionalValue new
		node: expectedNodeValue;
		environment: environment;
		yourself
]

{ #category : #converting }
SYMLLazyValue >> asFunctionalValue [
	^ SYMLFunctionalValue new
		node: node;
		environment: environment;
		yourself
]

{ #category : #evaluating }
SYMLLazyValue >> ensureEvaluation [
	isEvaluated ifTrue: [ ^ self ].
	cachedValue := node analyzeAndEvaluateInEnvironment: environment.
	isEvaluated := true.

]

{ #category : #accessing }
SYMLLazyValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLLazyValue >> environment: anObject [
	environment := anObject
]

{ #category : #evaluating }
SYMLLazyValue >> evaluateForAlias [
	self ensureEvaluation.
	^ cachedValue type isMetaObjectType ifTrue: [ cachedValue value ] ifFalse: [ cachedValue ]
]

{ #category : #initialization }
SYMLLazyValue >> initialize [
	super initialize.
	isEvaluated := false.
	
]

{ #category : #'as yet unclassified' }
SYMLLazyValue >> lazyValueForEnvironment: newEnvironment [
	^ SYMLLazyValue new
		node: node;
		environment: newEnvironment;
		yourself
]

{ #category : #'pattern matching' }
SYMLLazyValue >> matchValue: suppliedValue withMatchingContext: argumentMatchingContext at: position [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLLazyValue >> node [
	^ node
]

{ #category : #accessing }
SYMLLazyValue >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SYMLLazyValue >> position [
	^ node
]

{ #category : #'as yet unclassified' }
SYMLLazyValue >> sameValueButWithType: aNewType [
	self ensureEvaluation.
	^ cachedValue sameValueButWithType: aNewType
]

{ #category : #evaluating }
SYMLLazyValue >> type [
	self ensureEvaluation.
	^ cachedValue type
]

{ #category : #evaluating }
SYMLLazyValue >> value [
	self ensureEvaluation.
	^ cachedValue value
]
