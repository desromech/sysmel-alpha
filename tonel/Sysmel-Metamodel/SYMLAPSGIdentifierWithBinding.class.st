Class {
	#name : #SYMLAPSGIdentifierWithBinding,
	#superclass : #SYMLAPSGIdentifier,
	#instVars : [
		'binding'
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
	^ binding evaluateReferenceAt: position
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> evaluateTypeInEnvironment: anEnvironment [
	^ binding evaluateTypeAt: position
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> generateSSACodeWith: aBuilder [
	^ binding generateSSAReferenceWith: aBuilder
]

{ #category : #'meta evaluation' }
SYMLAPSGIdentifierWithBinding >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]
