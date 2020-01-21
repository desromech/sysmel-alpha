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

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> __identityHashValue [
	^ type identityHashField evaluateAggregateValue: self
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> __identityHashValue: value [
	^ type identityHashField evaluateSetAggregate: self value: (value asMoebiusValueWithTarget: self compilationTarget)
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> __variableDataSizeValue [
	^ type variableDataSizeField evaluateAggregateValue: self
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> __variableDataSizeValue: value [
	^ type variableDataSizeField evaluateSetAggregate: self value: (value asMoebiusValueWithTarget: self compilationTarget)
]

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

{ #category : #copying }
MbndAggregateTypeInstanceValue >> copyForValueAssignment [
	^ self copy
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> getFieldValue: fieldName [
	^ (type slotLayout findFirstFieldNamed: fieldName) evaluateAggregateValue: self
]

{ #category : #testing }
MbndAggregateTypeInstanceValue >> isAggregateTypeInstanceValue [
	^ true
]

{ #category : #copying }
MbndAggregateTypeInstanceValue >> postCopy [
	slots := slots copy
]

{ #category : #'as yet unclassified' }
MbndAggregateTypeInstanceValue >> resizeTo: newSize at: aPosition [
	| defaultValue |
	defaultValue := (type elementType defaultValueAt: aPosition) unwrapMbndValue.
	slots := (slots species new: newSize)
		atAllPut: defaultValue
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> setField: fieldName ifExistsWith: newValueBlock [
	(type slotLayout findFirstFieldNamed: fieldName) ifNotNil: [:field |
		field evaluateSetAggregate: self value: (newValueBlock value asMoebiusValueWithTarget: self compilationTarget)
	]
]

{ #category : #accessing }
MbndAggregateTypeInstanceValue >> setField: fieldName value: newFieldValue [
	^ (type slotLayout findFirstFieldNamed: fieldName) evaluateSetAggregate: self value: (newFieldValue asMoebiusValueWithTarget: self compilationTarget)
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
