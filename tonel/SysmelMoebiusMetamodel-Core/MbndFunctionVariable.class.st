Class {
	#name : #MbndFunctionVariable,
	#superclass : #MbndAbstractVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

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
