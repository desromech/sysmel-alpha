"
I am a concrete value that is augmented with type information.
"
Class {
	#name : #MbndValue,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'value',
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndValue class >> messagePackTypeName [
	^ #Value
]

{ #category : #'instance creation' }
MbndValue class >> value: aValue type: aType [
	^ self new value: aValue; type: aType; yourself
]

{ #category : #'semantic analysis' }
MbndValue >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode 
		position: referenceNode;
		yourself
]

{ #category : #converting }
MbndValue >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: value;
		type: type;
		yourself
]

{ #category : #converting }
MbndValue >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ self asLiteralValueNode
]

{ #category : #converting }
MbndValue >> asMoebiusValueWithType: aType [
	^ self copy type: aType; yourself
]

{ #category : #converting }
MbndValue >> asTupleWithCompileTimeValuesFor: compilationTarget [
	self assert: type isTupleType.
	^ self copy
		type: (compilationTarget tuple: (value collect: [:v | v mbndLiteralTypeWithTarget: compilationTarget]));
		yourself
]

{ #category : #serialization }
MbndValue >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#type . type encodeGraphForMessagePackWith: graphEncoder.
		#value . value encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #serialization }
MbndValue >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	type := encodedFields at: #type.
	value := encodedFields at: #value.
]

{ #category : #printing }
MbndValue >> printOn: aStream [
	aStream nextPut: $(; print: type; nextPut: $); print: value
]

{ #category : #accessing }
MbndValue >> type [
	^ type
]

{ #category : #accessing }
MbndValue >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
MbndValue >> unwrapMbndValue [
	^ value
]

{ #category : #accessing }
MbndValue >> value [
	^ value
]

{ #category : #accessing }
MbndValue >> value: anObject [
	value := anObject
]
