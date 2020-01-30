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
		'virtualTables',
		'identityHashField',
		'variableDataSizeField',
		'hasTrivialBasicInitialization'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateSlotLayout >> checkForTrivialBasicInitialization [
	virtualTables ifNotEmpty: [ ^ false ].
	^ self checkForTypeTriviality: #hasTrivialBasicInitialization
]

{ #category : #accessing }
MbndAggregateSlotLayout >> checkForTypeTriviality: aBlock [
	slots do: [ :slot |
		(aBlock value: slot type) ifFalse: [ ^ false ]
	].
	^ true
]

{ #category : #'as yet unclassified' }
MbndAggregateSlotLayout >> findFirstFieldNamed: fieldName [
	slots do: [ :slot |
		slot fields do: [ :field |
			field name == fieldName ifTrue: [ ^ field ]
		]
	].
	^ nil
]

{ #category : #accessing }
MbndAggregateSlotLayout >> getFieldOffset: fieldName [
	^ (self findFirstFieldNamed: fieldName) byteOffset
]

{ #category : #accessing }
MbndAggregateSlotLayout >> hasTrivialBasicInitialization [
	^ hasTrivialBasicInitialization ifNil: [ hasTrivialBasicInitialization := self checkForTrivialBasicInitialization ]
]

{ #category : #accessing }
MbndAggregateSlotLayout >> hasTrivialFinalization [
	^ self checkForTypeTriviality: #hasTrivialFinalization
]

{ #category : #accessing }
MbndAggregateSlotLayout >> hasTrivialInitialization [
	^ self checkForTypeTriviality: #hasTrivialInitialization
]

{ #category : #accessing }
MbndAggregateSlotLayout >> hasTrivialInitializationCopyingFrom [
	^ self checkForTypeTriviality: #hasTrivialInitializationCopyingFrom
]

{ #category : #accessing }
MbndAggregateSlotLayout >> hasTrivialInitializationMovingFrom [
	^ self checkForTypeTriviality: #hasTrivialInitializationMovingFrom
]

{ #category : #accessing }
MbndAggregateSlotLayout >> identityHashField [
	^ identityHashField ifNil: [ identityHashField := self findFirstFieldNamed: #__identityHash ]
]

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
MbndAggregateSlotLayout >> variableDataSizeField [
	^ variableDataSizeField ifNil: [ variableDataSizeField := self findFirstFieldNamed: #__variableDataSize ]
]

{ #category : #accessing }
MbndAggregateSlotLayout >> virtualTables [
	^ virtualTables
]

{ #category : #accessing }
MbndAggregateSlotLayout >> virtualTables: anObject [
	virtualTables := anObject
]
