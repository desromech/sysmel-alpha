Class {
	#name : #SYMLAPSGSequenceWithType,
	#superclass : #SYMLAPSGSequence,
	#instVars : [
		'valueType'
	],
	#category : #Sysmel-Metamodel-APSG
}

{ #category : #'as yet unclassified' }
SYMLAPSGSequenceWithType >> evaluateInEnvironment: anEnvironment [
	| result |
	result := nil.
	elements do: [ :expr | result := expr evaluateInEnvironment: anEnvironment ].
	^ result
]

{ #category : #'as yet unclassified' }
SYMLAPSGSequenceWithType >> evaluateTypeInEnvironment: anEnvironment [
	^ valueType
]

{ #category : #'meta evaluation' }
SYMLAPSGSequenceWithType >> generateSSACodeWith: builder [
	| result |
	result := nil.
	elements do: [ :expr | result := expr generateSSACodeWith: builder ].
	^ result
]

{ #category : #'meta evaluation' }
SYMLAPSGSequenceWithType >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLAPSGSequenceWithType >> valueType [
	^ valueType
]

{ #category : #accessing }
SYMLAPSGSequenceWithType >> valueType: anObject [
	valueType := anObject
]
