Class {
	#name : #SYMLAPSGMessageChainReceiverReference,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'chain',
		'receiverValue'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGMessageChainReceiverReference >> chain [
	^ chain
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverReference >> chain: anObject [
	chain := anObject
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverReference >> copyReplacingNode: oldNode with: newNode [
	| newReceiver |
	self == oldNode ifTrue: [ ^ newNode ].

	newReceiver := receiverValue == oldNode ifTrue: [ newNode ] ifFalse: [ receiverValue ].
	^ self shallowCopy
		receiverValue: newReceiver;
		chain: newReceiver chain;
		yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> evaluateInEnvironment: anEnvironment [
	^ anEnvironment lookSymbolRecursively: receiverValue ifAbsent: [ self error: 'Cannot evaluate chained receiver.' ]
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> evaluateTypeInEnvironment: anEnvironment [
	^ receiverValue evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> generateSSACodeWith: builder [
	builder withDebugPosition: self position do: [
		^ receiverValue ssaValue
	]
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverReference >> receiverValue [
	^ receiverValue
]

{ #category : #accessing }
SYMLAPSGMessageChainReceiverReference >> receiverValue: anObject [
	receiverValue := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> semanticAnalysisInEnvironment: anEnvironment [
	receiverValue receiver isMetaObjectInstance ifTrue: [ ^ receiverValue receiver ].
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> type [
	^ receiverValue type
]
