Class {
	#name : #SYMLStructureSlotsLayoutBuilder,
	#superclass : #Object,
	#instVars : [
		'slots',
		'currentBitFieldType',
		'remainingBitFieldBits',
		'currentBitFields'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> addBitField: aField [
	(aField type ~~ currentBitFieldType or: [ aField bits > remainingBitFieldBits ]) ifTrue: [ 
		self flushBitFieldForNewType: aField type.
	].

	aField bitOffset: remainingBitFieldBits - aField bits.
	remainingBitFieldBits := remainingBitFieldBits - aField bits.
	
	currentBitFields add: aField.
	(remainingBitFieldBits = 0 or: [aField bits = 0]) ifTrue: [ self flushBitFields ].

]

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> addField: aField [
	aField bits
		ifNil: [ self addNormalField: aField ]
		ifNotNil: [ self addBitField: aField ]
]

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> addNormalField: aField [
	self flushBitFields.
	aField slotIndex: slots size.
	slots add: (SYMLStructureSlotLayout new
		name: aField name;
		type: aField type;
		fields: {aField};
		slotIndex: aField slotIndex;
		yourself)
]

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> flush [
	self flushBitFields
]

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> flushBitFieldForNewType: aType [
	self flushBitFields.
	
	currentBitFieldType := aType.
	remainingBitFieldBits := aType instanceSize * 8.
]

{ #category : #adding }
SYMLStructureSlotsLayoutBuilder >> flushBitFields [
	| slotIndex |
	currentBitFields ifEmpty: [ ^ self ].

	slotIndex := slots size.
	currentBitFields do: [ :bf | bf slotIndex: slotIndex ].

	slots add: (SYMLStructureSlotLayout new
		name: #__bitfields;
		type: currentBitFieldType;
		fields: currentBitFields asArray;
		slotIndex: slotIndex;
		yourself).
	currentBitFields removeAll
]

{ #category : #initialization }
SYMLStructureSlotsLayoutBuilder >> initialize [
	super initialize.
	slots := OrderedCollection new.
	currentBitFields := OrderedCollection new.
]

{ #category : #accessing }
SYMLStructureSlotsLayoutBuilder >> slots [
	^ slots asArray
]
