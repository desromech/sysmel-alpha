Class {
	#name : #MbndAggregateTypeInstanceValue,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'type',
		'slots'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'semantic analysis' }
MbndAggregateTypeInstanceValue >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode 
		position: referenceNode;
		yourself
]

{ #category : #converting }
MbndAggregateTypeInstanceValue >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: type;
		yourself
]

{ #category : #converting }
MbndAggregateTypeInstanceValue >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ self asLiteralValueNode
]

{ #category : #'as yet unclassified' }
MbndAggregateTypeInstanceValue >> resizeTo: newSize at: aPosition [
	| defaultValue |
	defaultValue := (type elementType defaultValueAt: aPosition) unwrapMbndValue.
	slots := (slots species new: newSize)
		atAllPut: defaultValue
]

{ #category : #evaluating }
MbndAggregateTypeInstanceValue >> slotValues [
	^ slots collect: #value
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> slots [
	^ slots
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> type [
	^ type
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
MbndAggregateTypeInstanceValue >> value [
	^ self
]
