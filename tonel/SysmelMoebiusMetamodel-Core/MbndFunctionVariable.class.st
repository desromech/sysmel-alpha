Class {
	#name : #MbndFunctionVariable,
	#superclass : #MbndAbstractVariable,
	#instVars : [
		'immediateCaptures'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndFunctionVariable >> addImmediateCapture: aCapture [
	(immediateCaptures ifNil: [immediateCaptures := OrderedCollection new]) add: aCapture
]

{ #category : #'semantic analysis' }
MbndFunctionVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	"I could be a captured global variable."
	| currentFunction |
	(analyzer scope lookBindingStorageRecursively: self) ifNotNil: [ :binding |
		^ binding analyzeReferenceNode: referenceNode with: analyzer
	].

	parent isAbstractSpecificMethod ifTrue: [ 
		currentFunction := analyzer scope lookupFunctionProgramEntity.
		currentFunction ~~ parent ifTrue: [
			^ currentFunction analyzeReferenceNode: referenceNode toCapturedVariable: self with: analyzer
		].
	].

	^ super analyzeReferenceNode: referenceNode with: analyzer
]

{ #category : #testing }
MbndFunctionVariable >> hasCaptureInNonInlinedBlock [
	self immediateCaptures do: [ :each |
		each isCaptureInNonInlineBlock ifTrue: [
			^ true
		] ifFalse: [ 
			each hasCaptureInNonInlinedBlock ifTrue: [ ^ true ]
		].
	].

	^ false
]

{ #category : #accessing }
MbndFunctionVariable >> immediateCaptures [
	^ immediateCaptures ifNil: [ #() ]
]

{ #category : #testing }
MbndFunctionVariable >> isCaptureInNonInlineBlock [
	^ false
]
