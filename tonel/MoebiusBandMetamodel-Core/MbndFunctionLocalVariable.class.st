Class {
	#name : #MbndFunctionLocalVariable,
	#superclass : #MbndFunctionVariable,
	#instVars : [
		'type'
	],
	#category : #'MoebiusBandMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndFunctionLocalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndFunctionLocalVariable >> type: aType [
	type := aType
]
