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
