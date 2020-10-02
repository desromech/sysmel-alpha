Class {
	#name : #SysmelUnionAggregateLayout,
	#superclass : #SysmelAbstractAggregateLayout,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelUnionAggregateLayout >> computeOffsets [
	instanceSize := 0.
	instanceAlignment := 1.
	slots do: [ :each |
		| slotType |
		slotType := each type.
		instanceSize := instanceSize max: slotType instanceSize.
		instanceAlignment := instanceAlignment max: slotType instanceAlignment.
		each offset: 0.
	].
	instanceSize := instanceSize alignedTo: instanceAlignment
]
