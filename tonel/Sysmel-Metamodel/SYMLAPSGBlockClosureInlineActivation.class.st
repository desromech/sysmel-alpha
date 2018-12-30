Class {
	#name : #SYMLAPSGBlockClosureInlineActivation,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'blockClosure',
		'arguments'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> blockClosure [
	^ blockClosure
]

{ #category : #accessing }
SYMLAPSGBlockClosureInlineActivation >> blockClosure: anObject [
	blockClosure := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGBlockClosureInlineActivation >> semanticAnalysisInEnvironment: environment [
	self halt
]
