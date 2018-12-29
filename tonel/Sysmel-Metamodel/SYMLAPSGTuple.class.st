Class {
	#name : #SYMLAPSGTuple,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'elements'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGTuple >> associationKey [
	self assert: elements size = 2.
	^ elements first
]

{ #category : #accessing }
SYMLAPSGTuple >> associationValue [
	self assert: elements size = 2.
	^ elements second
]

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
SYMLAPSGTuple >> isTrivialWithoutSideEffects [
	elements do: [ :el | el isTrivialWithoutSideEffects ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #testing }
SYMLAPSGTuple >> isTupleNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGTuple >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		elements: (Array streamContents: [:out |
			elements do: [ :element |
				element isSplice ifTrue: [ 
					out nextPutAll: (element macroExpansionInEnvironment: anEnvironment)
				] ifFalse: [ 
					out nextPut: (element macroExpansionInEnvironment: anEnvironment)
				]
			]
		]);
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
