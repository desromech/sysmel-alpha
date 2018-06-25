Class {
	#name : #SYMLLazyValue,
	#superclass : #SYMLObject,
	#instVars : [
		'node',
		'environment',
		'isEvaluated',
		'cachedValue'
	],
	#category : #'Sysmel-Metamodel-Values'
}

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
