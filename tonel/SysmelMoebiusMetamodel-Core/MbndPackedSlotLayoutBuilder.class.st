Class {
	#name : #MbndPackedSlotLayoutBuilder,
	#superclass : #MbndAggregateSlotLayoutBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
MbndPackedSlotLayoutBuilder >> countSlotForSizeAndAlignment: slot [
	| slotType |
	slotType := slot type.
	slot offset: instanceSize.

	instanceSize := instanceSize + slotType instanceSize.
	instanceAlignment := 1
]
