Class {
	#name : #MbndSpecificCompilerObjectType,
	#superclass : #MbndAbstractSpecificCompilerObjectType,
	#instVars : [
		'behavior'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #serialization }
MbndSpecificCompilerObjectType class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	objectType == #SpecificCompilerObjectType ifTrue: [
		| behavior type |
		behavior := Smalltalk globals at: earlyFields.
		type := graphDecoder compilationTarget specificCompilerObjectTypeFor: behavior.
		graphDecoder registerObjectInstance: type.
		graphDecoder decodeNext. "These are ignored"
		^ type
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

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

{ #category : #serialization }
MbndSpecificCompilerObjectType >> encodeGraphForMessagePackWith: graphEncoder [
	behavior ifNotNil: [
		^ graphEncoder encodeObject: self type: self messagePackTypeName earlyFields: behavior name fields: [{}].
	].

	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
]

{ #category : #testing }
MbndSpecificCompilerObjectType >> isTrait [
	^ behavior isNotNil
]
