Class {
	#name : #MbndFunctionLocalVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndFunctionLocalVariable >> accept: visitor [
	^ visitor visitFunctionLocalVariable: self
]

{ #category : #testing }
MbndFunctionLocalVariable >> isFunctionLocalVariable [
	^ true
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type: aType [
	type := aType
]
