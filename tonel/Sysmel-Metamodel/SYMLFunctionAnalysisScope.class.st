Class {
	#name : #SYMLFunctionAnalysisScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'function',
		'receiver'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLFunctionAnalysisScope >> addLocalVariable: aLocalVariable at: aPosition [
	super addLocalVariable: aLocalVariable at: aPosition.
	function addLocal: aLocalVariable
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> function [
	^ function
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> function: anObject [
	function := anObject
]

{ #category : #testing }
SYMLFunctionAnalysisScope >> isImmediateEnvironment [
	^ false
]

{ #category : #'as yet unclassified' }
SYMLFunctionAnalysisScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	super lookSymbol: symbol ifPresent: [:found | ^ ifPresentBlock value: found ].
	^ self receiverType lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> receiver: anObject [
	receiver := anObject
]

{ #category : #'as yet unclassified' }
SYMLFunctionAnalysisScope >> receiverType [
	^ function receiverType
]

{ #category : #accessing }
SYMLFunctionAnalysisScope >> returnType [
	^ function returnType
]
