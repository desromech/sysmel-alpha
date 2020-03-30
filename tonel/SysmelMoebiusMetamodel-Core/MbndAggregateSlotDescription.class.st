Class {
	#name : #MbndAggregateSlotDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'fields',
		'slotIndex',
		'offset'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #serialization }
MbndAggregateSlotDescription class >> messagePackTypeName [
	^ #AggregateSlotDescription
]

{ #category : #accessing }
MbndAggregateSlotDescription >> alignment [
	| alignment |
	alignment := type instanceAlignment.
	(fields size = 1 and: [ fields first minimalAlignment isNotNil ]) ifTrue: [
		alignment := alignment max: fields first minimalAlignment
	].
	^ alignment
]

{ #category : #defaults }
MbndAggregateSlotDescription >> defaultValueAt: aPosition [
	(fields size = 1 and: [ fields first isVTablePointerField ]) ifTrue: [ 
		^ fields first defaultValueAt: aPosition
	].

	^ type defaultValueAt: aPosition
]

{ #category : #serialization }
MbndAggregateSlotDescription >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name encodeGraphForMessagePackWith: graphEncoder.
		#type . type encodeGraphForMessagePackWith: graphEncoder.
		#fields . fields encodeGraphForMessagePackWith: graphEncoder.
		#slotIndex . slotIndex encodeGraphForMessagePackWith: graphEncoder.
		#offset.  offset encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #serialization }
MbndAggregateSlotDescription >> encodeGraphForMessagePackWith: graphEncoder [
	^ graphEncoder encodeObject: self type: self messagePackTypeName fields: [self encodeFieldsForMessagePackWith: graphEncoder]
]

{ #category : #accessing }
MbndAggregateSlotDescription >> fields [
	^ fields
]

{ #category : #accessing }
MbndAggregateSlotDescription >> fields: anObject [
	fields := anObject
]

{ #category : #serialization }
MbndAggregateSlotDescription >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name.
	type := encodedFields at: #type.
	fields := encodedFields at: #fields.
	slotIndex := encodedFields at: #slotIndex.
	offset := encodedFields at: #offset.
]

{ #category : #serialization }
MbndAggregateSlotDescription >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #accessing }
MbndAggregateSlotDescription >> name [
	^ name
]

{ #category : #accessing }
MbndAggregateSlotDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAggregateSlotDescription >> offset [
	^ offset
]

{ #category : #accessing }
MbndAggregateSlotDescription >> offset: newOffset [
	offset := newOffset.
	fields do: [ :f | f byteOffset: newOffset ]
]

{ #category : #accessing }
MbndAggregateSlotDescription >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
MbndAggregateSlotDescription >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
MbndAggregateSlotDescription >> type [
	^ type
]

{ #category : #accessing }
MbndAggregateSlotDescription >> type: anObject [
	type := anObject
]
