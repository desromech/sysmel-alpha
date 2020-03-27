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

{ #category : #serialization }
MbndFieldVariable class >> messagePackTypeName [
	^ #Field
]

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

{ #category : #serialization }
MbndFieldVariable >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#bits . bits.
		#bitOffset . bitOffset .
		#bitMask . bitMask
	}
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

{ #category : #serialization }
MbndFieldVariable >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	bits := encodedFields at: #bits ifAbsent: [ nil ].
	bitOffset := encodedFields at: #bitOffset ifAbsent: [ nil ].
	bitMask := encodedFields at: #bitMask ifAbsent: [ nil ].
]

{ #category : #printing }
MbndFieldVariable >> printOn: aStream [
	aStream nextPutAll: 'field '; nextPutAll: self qualifiedName
]
