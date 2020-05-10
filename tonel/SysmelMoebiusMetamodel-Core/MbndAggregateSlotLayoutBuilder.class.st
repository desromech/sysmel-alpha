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
		'instanceAlignment',
		'typeStartLocations',
		'typeEndLocations',
		'activeVTableField',
		'mainVTableField',
		'vtableFields'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addBitField: aField [
	(aField valueType ~~ currentBitFieldType or: [ aField bits > remainingBitFieldBits ]) ifTrue: [ 
		self flushBitFieldForNewType: aField valueType.
	].

	aField slotIndex ifNil: [ 
		aField
			slotIndex: self currentSlotIndex;
			bitOffset: remainingBitFieldBits - aField bits;
			bitMask: ((1 << aField bits) - 1) << aField bitOffset.
	].
	remainingBitFieldBits := remainingBitFieldBits - aField bits.
	
	currentBitFields add: aField.
	(remainingBitFieldBits = 0 or: [aField bits = 0]) ifTrue: [ self flushBitFields ].

]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addField: aField [
	(aField isVTablePointerField and: [ mainVTableField isNil ]) ifTrue: [
		aField parent == aggregate ifTrue: [
			mainVTableField := activeVTableField := aField.
			vtableFields add: aField
		] ifFalse: [
			| newVTableField |
			newVTableField := self createVirtualTable.
			activeVTableField := newVTableField.
			mainVTableField ifNil: [ mainVTableField := newVTableField ].
			^ newVTableField
		]
	].

	aField bits
		ifNil: [ self addNormalField: aField ]
		ifNotNil: [ self addBitField: aField ]
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addNormalField: aField [
	| slot |
	self flushBitFields.

	slot := MbndAggregateSlotDescription new
		name: aField name;
		type: aField valueType;
		fields: {aField};
		slotIndex: aField slotIndex;
		yourself.
		
	self countSlotForSizeAndAlignment: slot.
	aField slotIndex ifNil: [ 
		aField slotIndex: self currentSlotIndex.
	].

	layout slots add: slot.

]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> addVirtualMethod: aMethod [
	aMethod isNewVirtualTableEntry ifTrue: [ 
		self assert: activeVTableField isNotNil.
		
		activeVTableField addNewVirtualMethodEntry: aMethod.
		mainVTableField ~~ activeVTableField ifTrue: [ 
			mainVTableField addNewVirtualMethodEntry: aMethod.
		].
	] ifFalse: [
		self assert: aMethod isVirtualTableOverride.
		vtableFields do: [ :vtable |
			vtable == mainVTableField ifTrue: [
				vtable overrideVirtualMethodEntryWith: aMethod
			] ifFalse: [
				vtable tryToOverrideVirtualMethodEntryWith: aMethod
			].
		]
	].

]

{ #category : #accessing }
MbndAggregateSlotLayoutBuilder >> aggregate [
	^ aggregate
]

{ #category : #accessing }
MbndAggregateSlotLayoutBuilder >> aggregate: anObject [
	aggregate := anObject
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> countSlotForSizeAndAlignment: slot [
	| slotType naturalAlignedOffset |
	slotType := slot type.
	
	naturalAlignedOffset := instanceSize alignedTo: slotType instanceAlignment.
	instanceSize := instanceSize alignedTo: slot alignment.
	self emitAdditionalPaddingBytes: instanceSize - naturalAlignedOffset.
	
	slot offset: instanceSize.
	
	instanceSize := instanceSize + slotType instanceSize.
	instanceAlignment := (instanceAlignment max: slotType instanceAlignment) max: slot alignment
]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayoutBuilder >> createMainVirtualTable [
	mainVTableField ifNil: [
		mainVTableField := activeVTableField := self createVirtualTable.
	].

	^ mainVTableField
]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayoutBuilder >> createVirtualTable [
	| vtableField fieldType |
	fieldType := aggregate vtableFieldType.
	vtableField := MbndVTablePointerFieldVariable new
		valueType: fieldType;
		type: fieldType ref.
	aggregate addChild: vtableField.
	self addNormalField: vtableField.
	vtableFields add: vtableField.
	^ vtableField
]

{ #category : #adding }
MbndAggregateSlotLayoutBuilder >> currentSlotIndex [
	^ layout slots size
]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayoutBuilder >> emitAdditionalPaddingBytes: paddingByteCount [
	paddingByteCount > 0 ifTrue: [
		layout slots add: (MbndAggregateSlotDescription new
			name: nil;
			type: (aggregate compilationTarget uint8Type array: paddingByteCount);
			fields: #();
			slotIndex: self currentSlotIndex;
			yourself
		).
	].

]

{ #category : #initialization }
MbndAggregateSlotLayoutBuilder >> finish [
	self flush.
	^ layout copy
		slots: layout slots asArray;
		instanceSize: instanceSize;
		instanceAlignment: instanceAlignment;
		typeStartLocations: typeStartLocations;
		typeEndLocations: typeEndLocations;
		mainVirtualTable: mainVTableField;
		virtualTables: vtableFields;
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
	typeStartLocations := OrderedDictionary new.
	typeEndLocations := OrderedDictionary new.
	vtableFields := OrderedCollection new.
	instanceSize := 0.
	instanceAlignment := 1.
]

{ #category : #accessing }
MbndAggregateSlotLayoutBuilder >> layout [
	^ layout
]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayoutBuilder >> recordTypeEndLocation: aType [
	self flush.
	instanceSize := instanceSize alignedTo: instanceAlignment.
	typeEndLocations at: aType ifAbsentPut: [ layout slots size ].

]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayoutBuilder >> recordTypeStartLocation: aType [
	self flush.
	typeStartLocations at: aType ifAbsentPut: [ layout slots size ].
]
