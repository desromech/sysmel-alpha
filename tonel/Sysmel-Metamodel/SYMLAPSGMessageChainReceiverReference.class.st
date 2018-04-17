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

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> evaluateTypeInEnvironment: anEnvironment [
	^ receiverValue evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGMessageChainReceiverReference >> generateSSACodeWith: builder [
	^ receiverValue ssaValue
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
