Class {
	#name : #SysmelStructureAggregateLayout,
	#superclass : #SysmelAbstractAggregateLayout,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelStructureAggregateLayout >> computeOffsets [
	instanceSize := 0.
	instanceAlignment := 1.
	slots do: [ :each |
		| slotType |
		slotType := each type.
		instanceSize := instanceSize alignedTo: slotType instanceAlignment.
		instanceAlignment := instanceAlignment max: slotType instanceAlignment.
		each offset: instanceSize.
		instanceSize := instanceSize + slotType instanceSize
	].
	instanceSize := instanceSize alignedTo: instanceAlignment
]
