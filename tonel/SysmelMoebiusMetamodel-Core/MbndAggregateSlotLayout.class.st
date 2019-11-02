Class {
	#name : #MbndAggregateSlotLayout,
	#superclass : #Object,
	#instVars : [
		'slots',
		'instanceSize',
		'instanceAlignment',
		'typeStartLocations',
		'typeEndLocations',
		'mainVirtualTable',
		'virtualTables'
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
MbndAggregateSlotLayout >> mainVirtualTable [
	^ mainVirtualTable
]

{ #category : #accessing }
MbndAggregateSlotLayout >> mainVirtualTable: anObject [
	mainVirtualTable := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> slots [
	^ slots
]

{ #category : #accessing }
MbndAggregateSlotLayout >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> typeEndLocations [
	^ typeEndLocations
]

{ #category : #accessing }
MbndAggregateSlotLayout >> typeEndLocations: anObject [
	typeEndLocations := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> typeStartLocations [
	^ typeStartLocations
]

{ #category : #accessing }
MbndAggregateSlotLayout >> typeStartLocations: anObject [
	typeStartLocations := anObject
]

{ #category : #accessing }
MbndAggregateSlotLayout >> virtualTables [
	^ virtualTables
]

{ #category : #accessing }
MbndAggregateSlotLayout >> virtualTables: anObject [
	virtualTables := anObject
]
