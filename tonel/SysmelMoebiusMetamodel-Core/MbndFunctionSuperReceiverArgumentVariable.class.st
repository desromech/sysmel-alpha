Class {
	#name : #MbndFunctionSuperReceiverArgumentVariable,
	#superclass : #MbndFunctionDerivedVariable,
	#instVars : [
		'vanillaReceiverVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionSuperReceiverArgumentVariable class >> messagePackTypeName [
	^ #FunctionSuperReceiver
]

{ #category : #'semantic analysis' }
MbndFunctionSuperReceiverArgumentVariable >> analyzeReferenceNode: referenceNode with: analyzer [
	"I could be a captured global variable."
	(analyzer scope lookBindingStorageRecursively: vanillaReceiverVariable) ifNotNil: [ :binding |
		^ binding analyzeReferenceNode: referenceNode with: analyzer
	].

	^ super analyzeReferenceNode: referenceNode with: analyzer
]

{ #category : #'compile time evaluation' }
MbndFunctionSuperReceiverArgumentVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	^ vanillaReceiverVariable asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node
]

{ #category : #testing }
MbndFunctionSuperReceiverArgumentVariable >> isFunctionSuperReceiverArgumentVariable [
	^ true
]

{ #category : #testing }
MbndFunctionSuperReceiverArgumentVariable >> isFunctionSuperReceiverReference [
	^ true
]

{ #category : #accessing }
MbndFunctionSuperReceiverArgumentVariable >> vanillaReceiverVariable [
	^ vanillaReceiverVariable
]

{ #category : #accessing }
MbndFunctionSuperReceiverArgumentVariable >> vanillaReceiverVariable: anObject [
	vanillaReceiverVariable := anObject
]
