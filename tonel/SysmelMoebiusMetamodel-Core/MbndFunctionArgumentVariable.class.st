Class {
	#name : #MbndFunctionArgumentVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'argumentIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndFunctionArgumentVariable >> accept: visitor [
	^ visitor visitFunctionArgumentVariable: self
]

{ #category : #accessing }
MbndFunctionArgumentVariable >> argumentIndex [
	^ argumentIndex
]

{ #category : #accessing }
MbndFunctionArgumentVariable >> argumentIndex: anObject [
	argumentIndex := anObject
]

{ #category : #'compile time evaluation' }
MbndFunctionArgumentVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	self assert: referenceType = self type.
	^ evaluator scope lookBindingStorageRecursively: self
]

{ #category : #'as yet unclassified' }
MbndFunctionArgumentVariable >> createStorageInFunctionActivationScope: scope withValue: activationValue [
	^ scope setBinding: self storage: activationValue
]
