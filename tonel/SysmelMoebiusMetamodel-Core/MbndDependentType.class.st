Class {
	#name : #MbndDependentType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDependentType class >> typeName [
	^ #_DependentType
]

{ #category : #converting }
MbndDependentType >> asConcreteTypeForAnalysisOfFunction: aFunction [
	^ self asConcreteTypeForAnalysisOfFunctionType: aFunction type
]

{ #category : #converting }
MbndDependentType >> asConcreteTypeForAnalysisOfFunctionType: functionType [
	self subclassResponsibility
]

{ #category : #testing }
MbndDependentType >> isDependentType [
	^ true
]
