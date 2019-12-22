Class {
	#name : #MbndFunctionDerivedVariable,
	#superclass : #MbndFunctionVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'compile time evaluation' }
MbndFunctionDerivedVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	self subclassResponsibility
]
