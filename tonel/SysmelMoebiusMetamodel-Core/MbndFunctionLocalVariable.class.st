Class {
	#name : #MbndFunctionLocalVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndFunctionLocalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type: aType [
	type := aType
]
