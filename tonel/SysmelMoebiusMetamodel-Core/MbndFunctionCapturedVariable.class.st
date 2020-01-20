Class {
	#name : #MbndFunctionCapturedVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'upperContextVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndFunctionCapturedVariable >> accept: visitor [
	^ visitor visitFunctionCapturedVariable: self
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> definitionNode [
	^ upperContextVariable definitionNode
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> definitionPosition [
	^ upperContextVariable definitionPosition
]

{ #category : #testing }
MbndFunctionCapturedVariable >> isFunctionCapturedVariable [
	^ true
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> type [
	^ upperContextVariable type
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> upperContextVariable [
	^ upperContextVariable
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> upperContextVariable: anObject [
	upperContextVariable := anObject.
	valueType := upperContextVariable.
]
