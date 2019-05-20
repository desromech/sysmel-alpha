Class {
	#name : #MbndUnionSlotLayoutBuilder,
	#superclass : #MbndAggregateSlotLayoutBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
MbndUnionSlotLayoutBuilder >> countSlotForSizeAndAlignment: slot [
	| slotType |
	slotType := slot type.
	slot offset: 0.
	
	instanceSize := instanceSize max: slotType instanceSize.
	instanceAlignment := instanceAlignment max: slotType instanceAlignment
]
