Class {
	#name : #SYMLAPSGTuple,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'elements'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGTuple >> children [
	^ elements
]

{ #category : #accessing }
SYMLAPSGTuple >> elements [
	^ elements
]

{ #category : #accessing }
SYMLAPSGTuple >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
SYMLAPSGTuple >> isTupleNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGTuple >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		elements: (elements collect: [ :element | element macroExpansionInEnvironment: anEnvironment ]);
		yourself
]

{ #category : #copying }
SYMLAPSGTuple >> postCopy [
	elements := elements collect: #copy
]

{ #category : #printing }
SYMLAPSGTuple >> printOn: aStream [
	aStream nextPutAll: 'tuple'
]

{ #category : #'meta evaluation' }
SYMLAPSGTuple >> semanticAnalysisInEnvironment: anEnvironment [
	| result type |
	result := SYMLAPSGTupleWithType new elements: (elements collect: [:el | (el semanticAnalysisInEnvironment: anEnvironment) asNodeForTupleElementIn: anEnvironment  ]).
	type := anEnvironment compilationTarget tuple: (result elements collect: [ :el | el evaluateTypeInEnvironment: anEnvironment ]).
	result type: type.
	^ result
]
