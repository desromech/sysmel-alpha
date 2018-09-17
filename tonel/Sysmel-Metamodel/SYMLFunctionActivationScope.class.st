Class {
	#name : #SYMLFunctionActivationScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'function',
		'receiver',
		'receiverVariable'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLFunctionActivationScope >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionActivationScope >> function: anObject [
	function := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionActivationScope >> lookReceiverValueFor: aReceiverVariable [
	receiverVariable == aReceiverVariable ifTrue: [ ^ receiver ].
	^ super lookReceiverValueFor: aReceiverVariable
	
]

{ #category : #'as yet unclassified' }
SYMLFunctionActivationScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	super lookSymbol: symbol ifPresent: [:found | ^ ifPresentBlock value: found ].
	^ self receiverType lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock
]

{ #category : #'instance creation' }
SYMLFunctionActivationScope >> newLexicalScope [
	^ (self class parent: self)
		function: function;
		receiver: receiver;
		receiverVariable: receiverVariable;
		yourself
]

{ #category : #accessing }
SYMLFunctionActivationScope >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLFunctionActivationScope >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SYMLFunctionActivationScope >> receiverType [
	^ function receiverType
]

{ #category : #accessing }
SYMLFunctionActivationScope >> receiverVariable [
	^ receiverVariable
]

{ #category : #accessing }
SYMLFunctionActivationScope >> receiverVariable: anObject [
	receiverVariable := anObject
]

{ #category : #accessing }
SYMLFunctionActivationScope >> returnType [
	^ function returnType asConcreteTypeForFunctionAnalysis
]
