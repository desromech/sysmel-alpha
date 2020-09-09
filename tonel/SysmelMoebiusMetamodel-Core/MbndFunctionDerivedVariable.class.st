Class {
	#name : #MbndFunctionDerivedVariable,
	#superclass : #MbndFunctionVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionDerivedVariable class >> messagePackTypeName [
	^ #FunctionDerivedVariable
]

{ #category : #'compile time evaluation' }
MbndFunctionDerivedVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	self subclassResponsibility
]

{ #category : #testing }
MbndFunctionDerivedVariable >> isFunctionDerivedVariable [
	^ true
]
