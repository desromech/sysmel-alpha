Class {
	#name : #SYMLAPSGMessageChainReceiverValue,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'chain',
		'receiver',
		'ssaValue'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGMessageChainReceiverValue >> chain [
	^ chain
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverValue >> chain: anObject [
	chain := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> evaluateInEnvironment: anEnvironment [
	| activationValue |
	activationValue := receiver evaluateInEnvironment: anEnvironment.
	anEnvironment setSymbol: self value: activationValue
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> evaluateTypeInEnvironment: anEnvironment [
	^ receiver evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> generateSSACodeWith: builder [
	builder withDebugPosition: self position do: [
		ssaValue := receiver generateSSACodeWith: builder
	]
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverValue >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverValue >> receiver: anObject [
	receiver := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverValue >> ssaValue [
	^ ssaValue
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverValue >> type [
	^ receiver type
]
