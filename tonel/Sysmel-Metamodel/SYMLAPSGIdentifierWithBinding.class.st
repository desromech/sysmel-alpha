Class {
	#name : #SYMLAPSGIdentifierWithBinding,
	#superclass : #SYMLAPSGIdentifier,
	#instVars : [
		'binding',
		'type'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> binding [
	^ binding
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> binding: anObject [
	binding := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> evaluateInEnvironment: anEnvironment [
	| evaluatedBinding |
	evaluatedBinding := anEnvironment lookSymbolRecursively: value ifAbsent: [
		self error: 'Failed to find identifier {1}.' format: { value } at: position
	].

	evaluatedBinding isSysmelValue ifFalse: [ ^ evaluatedBinding asIncompleteValue ].
	^ evaluatedBinding
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> evaluateTypeInEnvironment: environment [
	^ type
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> generateSSACodeWith: aBuilder [
	^ binding generateSSAReferenceWith: aBuilder
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> type [
	^ type
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> type: anObject [
	type := anObject
]
