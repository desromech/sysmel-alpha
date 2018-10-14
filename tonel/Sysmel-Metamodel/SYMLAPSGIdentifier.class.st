Class {
	#name : #SYMLAPSGIdentifier,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'as yet unclassified' }
SYMLAPSGIdentifier >> -- aSymbolOrIdentifier [
	<compileTime>
	| symbolValue |
	symbolValue := aSymbolOrIdentifier isSymbol
		ifTrue: [ aSymbolOrIdentifier ]
		ifFalse: [ aSymbolOrIdentifier value ].
	^ SYMLAPSGIdentifier new
		position: position;
		value: (value , symbolValue) asSymbol;
		yourself
]

{ #category : #accessing }
SYMLAPSGIdentifier >> bindIntoOverloadedAlternative: anAlternative inEnvironment: environment [
	^ anAlternative analyzeAPSGIdentifierToMe: self inEnvironment: environment
]

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

{ #category : #'as yet unclassified' }
SYMLAPSGIdentifier >> similarFor: aSymbolOrIdentifier [
	<compileTime>
	| symbolValue |
	symbolValue := aSymbolOrIdentifier isSymbol
		ifTrue: [ aSymbolOrIdentifier ]
		ifFalse: [ aSymbolOrIdentifier value ].
	^ SYMLAPSGIdentifier new
		position: position;
		value: symbolValue asSymbol;
		yourself
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value [
	<compileTime>
	^ value
]

{ #category : #accessing }
SYMLAPSGIdentifier >> value: anObject [
	<compileTime>
	value := anObject
]
