Class {
	#name : #MbndArraySliceType,
	#superclass : #MbndSequenceableAggregateType,
	#instVars : [
		'elementType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArraySliceType class >> typeName [
	^ #_ArraySliceType
]

{ #category : #converting }
MbndArraySliceType >> asImmutableValueType [
	^ self
]

{ #category : #accessing }
MbndArraySliceType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndArraySliceType >> elementType: anObject [
	elementType := anObject
]

{ #category : #sizes }
MbndArraySliceType >> instanceAlignment [
	<compileTime>
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndArraySliceType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #testing }
MbndArraySliceType >> isArraySliceType [
	^ true
]
