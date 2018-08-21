Class {
	#name : #SYMLFunctionalValue,
	#superclass : #SYMLAbstractValue,
	#instVars : [
		'node',
		'environment'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #testing }
SYMLFunctionalValue >> analyzeAndEvaluateInEnvironment: anActivationEnvironment [
	^ node analyzeAndEvaluateInEnvironment: anActivationEnvironment
]

{ #category : #converting }
SYMLFunctionalValue >> asAPSGNodeValueWithError: error [
	^ node
]

{ #category : #converting }
SYMLFunctionalValue >> asAPSGNodeValueWithError: error at: aPosition [
	^ node
]

{ #category : #converting }
SYMLFunctionalValue >> asAPSGNodeValueWithError: error format: format at: aPosition [
	^ node
]

{ #category : #converting }
SYMLFunctionalValue >> asFunctionalValue [
	^ self
]

{ #category : #accessing }
SYMLFunctionalValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLFunctionalValue >> environment: anObject [
	environment := anObject
]

{ #category : #testing }
SYMLFunctionalValue >> isFunctionalValue [
	^ true
]

{ #category : #accessing }
SYMLFunctionalValue >> node [
	^ node
]

{ #category : #accessing }
SYMLFunctionalValue >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SYMLFunctionalValue >> value [
	^ node
]
