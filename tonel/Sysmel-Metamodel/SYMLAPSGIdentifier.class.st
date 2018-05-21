Class {
	#name : #SYMLAPSGIdentifier,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #copying }
SYMLAPSGIdentifier >> copyWithBinding: binding andType: type [
	^ SYMLAPSGIdentifierWithBinding new
		position: position;
		value: value;
		binding: binding;
		type: type;
		yourself
]

{ #category : #testing }
SYMLAPSGIdentifier >> isIdentifierNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifier >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #printing }
SYMLAPSGIdentifier >> printOn: aStream [
	aStream nextPutAll: 'identifier '; print: value
]

{ #category : #accessing }
SYMLAPSGIdentifier >> semanticAnalysisInEnvironment: anEnvironment [
	| binding |
	binding := anEnvironment lookSymbolRecursively: value ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { value } at: position
	].

	^ binding analyzeAPSGIdentifierToMe: self inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value [
	^ value
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value: anObject [
	value := anObject
]
