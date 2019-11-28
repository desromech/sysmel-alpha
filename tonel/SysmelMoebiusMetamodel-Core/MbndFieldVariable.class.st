Class {
	#name : #MbndFieldVariable,
	#superclass : #MbndAbstractFieldVariable,
	#instVars : [
		'bits',
		'bitOffset',
		'bitMask'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndFieldVariable >> accept: aVisitor [
	^ aVisitor visitFieldVariable: self
]

{ #category : #accessing }
MbndFieldVariable >> bitMask [
	^ bitMask
]

{ #category : #accessing }
MbndFieldVariable >> bitMask: anObject [
	bitMask := anObject
]

{ #category : #accessing }
MbndFieldVariable >> bitOffset [
	^ bitOffset
]

{ #category : #accessing }
MbndFieldVariable >> bitOffset: anObject [
	bitOffset := anObject
]

{ #category : #accessing }
MbndFieldVariable >> bits [
	^ bits
]

{ #category : #accessing }
MbndFieldVariable >> bits: anObject [
	bits := anObject
]

{ #category : #'as yet unclassified' }
MbndFieldVariable >> evaluateAggregateValue: aggregate [
	bits ifNil: [ ^ super evaluateAggregateValue: aggregate ].
	^ MbndValue value: ((aggregate slots at: slotIndex + 1) & bitMask) >> bitOffset type: type
]

{ #category : #'as yet unclassified' }
MbndFieldVariable >> evaluateSetAggregate: aggregate value: newValue [
	| oldValue newSlotValue |
	bits ifNil: [ ^ super evaluateSetAggregate: aggregate value: newValue ].
	oldValue := aggregate slots at: slotIndex + 1.
	newSlotValue := (oldValue & bitMask bitInvert) bitOr:
		((newValue unwrapMbndValue << bitOffset) bitAnd: bitMask).
	aggregate slots at: slotIndex + 1 put: newSlotValue.
	^ aggregate
]

{ #category : #testing }
MbndFieldVariable >> isFieldVariable [
	^ true
]
