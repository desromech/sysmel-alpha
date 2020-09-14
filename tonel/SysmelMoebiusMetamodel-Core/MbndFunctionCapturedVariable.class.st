Class {
	#name : #MbndFunctionCapturedVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'upperContextVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #serialization }
MbndFunctionCapturedVariable class >> messagePackTypeName [
	^ #FunctionCapturedVariable
]

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

{ #category : #serialization }
MbndFunctionCapturedVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#upperContextVariable . upperContextVariable encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #testing }
MbndFunctionCapturedVariable >> isCaptureInNonInlineBlock [
	^ parent isBlockClosureWithImmediateActivation not
]

{ #category : #testing }
MbndFunctionCapturedVariable >> isFunctionCapturedVariable [
	^ true
]

{ #category : #testing }
MbndFunctionCapturedVariable >> isFunctionSuperReceiverReference [
	^ upperContextVariable isFunctionSuperReceiverReference
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> type [
	^ upperContextVariable type
]

{ #category : #accessing }
MbndFunctionCapturedVariable >> upperContextNonCaptureVariable [
	| position |
	position := self.
	[position isFunctionCapturedVariable] whileTrue: [ position := position upperContextVariable ].
	^ position
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
