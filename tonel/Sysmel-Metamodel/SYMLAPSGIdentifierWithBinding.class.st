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
	evaluatedBinding := binding evaluateBoundIdentifierToMe: self inEnvironment: anEnvironment.
	evaluatedBinding isSysmelValue ifFalse: [ ^ evaluatedBinding asIncompleteValue ].
	^ evaluatedBinding
]

{ #category : #accessing }
SYMLAPSGIdentifierWithBinding >> evaluateTypeInEnvironment: environment [
	^ type
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> generateSSACodeWith: aBuilder [
	aBuilder withDebugPosition: self position do: [
		^ binding generateSSAReferenceWith: aBuilder
	]
]

{ #category : #testing }
SYMLAPSGIdentifierWithBinding >> isSysmelIncompleteValueInEnvironment: anEnvironment [
	^ binding isSysmelIncompleteValueInEnvironment: anEnvironment
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
