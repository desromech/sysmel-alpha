Class {
	#name : #MbndFunctionVariable,
	#superclass : #MbndAbstractVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
MbndFunctionVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	"I could be a captured global variable."
	(analyzer scope lookBindingStorageRecursively: self) ifNotNil: [ :binding |
		^ binding analyzeReferenceNode: referenceNode with: analyzer
	].

	^ super analyzeReferenceNode: referenceNode with: analyzer
]
