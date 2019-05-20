Class {
	#name : #MbndAggregateSlotLayoutBuilder,
	#superclass : #Object,
	#instVars : [
		'currentBitFieldType',
		'remainingBitFieldBits',
		'currentBitFields',
		'aggregate',
		'layout',
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addBitField: aField [
	(aField type ~~ currentBitFieldType or: [ aField bits > remainingBitFieldBits ]) ifTrue: [ 
		self flushBitFieldForNewType: aField valueType.
	].

	aField
		slotIndex: self currentSlotIndex;
		bitOffset: remainingBitFieldBits - aField bits;
		bitMask: ((1 << aField bits) - 1) << aField bitOffset.
	remainingBitFieldBits := remainingBitFieldBits - aField bits.
	
	currentBitFields add: aField.
	(remainingBitFieldBits = 0 or: [aField bits = 0]) ifTrue: [ self flushBitFields ].

]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addField: aField [
	aField bits
		ifNil: [ self addNormalField: aField ]
		ifNotNil: [ self addBitField: aField ]
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addNormalField: aField [
	| slot |
	self flushBitFields.
	aField slotIndex: self currentSlotIndex.
	slot := MbndAggregateSlotDescription new
		name: aField name;
		type: aField valueType;
		fields: {aField};
		slotIndex: aField slotIndex;
		yourself.
		
	layout slots add: slot.
	self countSlotForSizeAndAlignment: slot.
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addVTablePointerField: vtableField [
	self flushBitFields.
	vtableField slotIndex: self currentSlotIndex.
	aggregate buildVTableFieldLayout: vtableField.
	self addNormalField: vtableField.

]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> countSlotForSizeAndAlignment: slot [
	| slotType |
	slotType := slot type.
	
	instanceSize := instanceSize alignedTo: slotType instanceAlignment.
	slot offset: instanceSize.
	
	instanceSize := instanceSize + slotType instanceSize.
	instanceAlignment := instanceAlignment max: slotType instanceAlignment
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> currentSlotIndex [
	^ layout slots size
]

{ #category : #initialization }
MbndAggregateSlotLayoutBuilder >> finish [
	self flush.
	^ layout copy
		slots: layout asArray;
		instanceSize: instanceSize;
		instanceAlignment: instanceAlignment;
		yourself
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> flush [
	self flushBitFields
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> flushBitFieldForNewType: aType [
	self flushBitFields.
	
	currentBitFieldType := aType.
	remainingBitFieldBits := aType instanceSize * 8.
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> flushBitFields [
	| slotIndex slot |
	currentBitFields ifEmpty: [ ^ self ].

	slotIndex := self currentSlotIndex.
	currentBitFields do: [ :bf | bf slotIndex: slotIndex ].

	slot := MbndAggregateSlotDescription new
		name: #__bitfields;
		type: currentBitFieldType;
		fields: currentBitFields asArray;
		slotIndex: slotIndex;
		yourself.
		
	layout slots add: slot.
	currentBitFields removeAll.
	self countSlotForSizeAndAlignment: slot 
]

{ #category : #initialization }
MbndAggregateSlotLayoutBuilder >> initialize [
	super initialize.
	layout := MbndAggregateSlotLayout new.
	currentBitFields := OrderedCollection new.
	instanceSize := 0.
	instanceAlignment := 1.
]

{ #category : #accessing }
MbndAggregateSlotLayoutBuilder >> layout [
	^ layout
]
