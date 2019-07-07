Class {
	#name : #MbndSpecificCompilerObjectType,
	#superclass : #MbndAbstractSpecificCompilerObjectType,
	#instVars : [
		'behavior'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSpecificCompilerObjectType class >> typeName [
	^ #_SpecificCompilerObjectType
]

{ #category : #accessing }
MbndSpecificCompilerObjectType >> behavior [
	^ behavior
]

{ #category : #accessing }
MbndSpecificCompilerObjectType >> behavior: anObject [
	behavior := anObject
]
