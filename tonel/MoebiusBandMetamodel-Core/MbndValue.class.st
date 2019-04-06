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
	#category : #'MoebiusBandMetamodel-Core-Values'
}

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
