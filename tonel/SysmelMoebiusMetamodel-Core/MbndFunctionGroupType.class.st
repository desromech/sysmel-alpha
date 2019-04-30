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
	"TODO: Solve the correct overloaded version of the function"
	self halt
]
