Class {
	#name : #MbndAggregateSlotLayout,
	#superclass : #Object,
	#instVars : [
		'slots',
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #initialization }
MbndAggregateSlotLayout >> initialize [
	super initialize.
	slots := OrderedCollection new.
]

{ #category : #accessing }
MbndAggregateSlotLayout >> instanceAlignment [
	<compileTime>
	^ instanceAlignment
]

{ #category : #accessing }
MbndAggregateSlotLayout >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> instanceSize [
	<compileTime>
	^ instanceSize
]

{ #category : #accessing }
MbndAggregateSlotLayout >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> slots [
	^ slots
]

{ #category : #accessing }
MbndAggregateSlotLayout >> slots: anObject [
	slots := anObject
]
