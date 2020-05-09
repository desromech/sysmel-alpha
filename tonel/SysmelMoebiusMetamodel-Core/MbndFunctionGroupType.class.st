Class {
	#name : #MbndFunctionGroupType,
	#superclass : #MbndFunctionalType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionGroupType class >> typeName [
	^ #_FunctionGroupType
]

{ #category : #visiting }
MbndFunctionGroupType >> accept: aVisitor [
	^ aVisitor visitFunctionGroupType: self
]

{ #category : #'as yet unclassified' }
MbndFunctionGroupType >> analyzeFunctionCallNode: node with: analyzer [
	^ node function binding analyzeFunctionCallNode: node with: analyzer

]
