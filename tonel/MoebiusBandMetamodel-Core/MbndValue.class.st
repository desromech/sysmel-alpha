"
I am a concrete value that is augmented with type information.
"
Class {
	#name : #MbndValue,
	#superclass : #MbndAbstractValue,
	#instVars : [
		'value',
		'type'
	],
	#category : #'MoebiusBandMetamodel-Core-Values'
}

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
