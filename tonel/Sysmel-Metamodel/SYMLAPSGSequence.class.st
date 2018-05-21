Class {
	#name : #SYMLAPSGSequence,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'elements'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGSequence >> children [
	^ elements
]

{ #category : #enumerating }
SYMLAPSGSequence >> collect: aBlock [
	^ elements collect: aBlock
]

{ #category : #'as yet unclassified' }
SYMLAPSGSequence >> do: aBlock [
	^ elements do: aBlock
]

{ #category : #accessing }
SYMLAPSGSequence >> elements [
	^ elements
]

{ #category : #accessing }
SYMLAPSGSequence >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
SYMLAPSGSequence >> isSequenceNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGSequence >> macroExpansionInEnvironment: anEnvironment [
	^ self shallowCopy
		elements: (elements collect: [ :element | element macroExpansionInEnvironment: anEnvironment ]);
		yourself
]

{ #category : #copying }
SYMLAPSGSequence >> postCopy [
	elements := elements collect: #copy
]

{ #category : #printing }
SYMLAPSGSequence >> printOn: aStream [
	aStream nextPutAll: 'sequence'
]

{ #category : #'meta evaluation' }
SYMLAPSGSequence >> semanticAnalysisInEnvironment: anEnvironment [
	| analyzedElements |
	analyzedElements := elements collect: [ :element | (element semanticAnalysisInEnvironment: anEnvironment) asNodeForSequenceElementIn: anEnvironment ].
	^ SYMLAPSGSequenceWithType new
		position: self;
		elements: analyzedElements;
		valueType: (analyzedElements ifEmpty: [anEnvironment compilationTarget voidType] ifNotEmpty: [analyzedElements last evaluateTypeInEnvironment: anEnvironment]);
		yourself
]
