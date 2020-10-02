Class {
	#name : #SysmelGenericStructureType,
	#superclass : #SysmelStructureType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelGenericStructureType class >> extractAggregateLayout [
	| slots |
	slots := self classLayout allSlots collect: [ :each |
		SysmelAggregateSlotDescription new
			name: each name;
			instanceVariableIndex: each index;
			type: (self typeOfGenericSlotNamed: each name)
			yourself
	].
	^ self aggregateLayoutKind new
		slots: slots;
		computeOffsets;
		yourself
]

{ #category : #'as yet unclassified' }
SysmelGenericStructureType class >> typeOfGenericSlotNamed: slotName [
	self error: 'The type for slot ', slotName , ' must be specified explicitly.'
]
