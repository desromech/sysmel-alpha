Class {
	#name : #SYMLAPSGSequence,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'pragmas',
		'elements'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGSequence >> analyzeAndEvaluateInEnvironment: anEnvironment [
	| result |
	result := nil.
	elements do: [ :el | result := el analyzeAndEvaluateInEnvironment: anEnvironment ].
	^ result
]

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

{ #category : #initialization }
SYMLAPSGSequence >> initialize [
	super initialize.
	pragmas := #()
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
	pragmas := pragmas collect: #copy.
	elements := elements collect: #copy.
]

{ #category : #accessing }
SYMLAPSGSequence >> pragmaAt: selector [
	pragmas do: [ :pragma |
		pragma selector == selector ifTrue: [ ^ pragma ]
	].
	^ nil
]

{ #category : #accessing }
SYMLAPSGSequence >> pragmaAt: selector ifAbsent: ifAbsentBlock [
	^ (self pragmaAt: selector) ifNil: [ ifAbsentBlock value ]
]

{ #category : #accessing }
SYMLAPSGSequence >> pragmaAt: selector ifPresent: ifPresentBlock [
	^ (self pragmaAt: selector) ifNotNil: [ :pragma | ifPresentBlock value: pragma ]
]

{ #category : #accessing }
SYMLAPSGSequence >> pragmas [
	^ pragmas
]

{ #category : #accessing }
SYMLAPSGSequence >> pragmas: anObject [
	pragmas := anObject
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
		pragmas: (pragmas collect: [:pragma | pragma semanticAnalysisInEnvironment: anEnvironment]);
		elements: analyzedElements;
		valueType: (analyzedElements ifEmpty: [anEnvironment compilationTarget voidType] ifNotEmpty: [analyzedElements last evaluateTypeInEnvironment: anEnvironment]);
		yourself
]
