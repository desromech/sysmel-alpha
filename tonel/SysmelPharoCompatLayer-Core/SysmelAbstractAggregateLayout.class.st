Class {
	#name : #SysmelAbstractAggregateLayout,
	#superclass : #Object,
	#instVars : [
		'slots',
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelAbstractAggregateLayout >> computeOffsets [
	self subclassResponsibility
]

{ #category : #initialization }
SysmelAbstractAggregateLayout >> initializeInstance: instance [
	slots do: [ :each | each initializeInstance: instance ]
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> instanceAlignment [
	^ instanceAlignment
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> instanceSize [
	^ instanceSize
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #'as yet unclassified' }
SysmelAbstractAggregateLayout >> readBytesFrom: aByteArray position: byteArrayPosition intoInstance: instance [
	slots do: [ :each |
		each readBytesFrom: aByteArray position: byteArrayPosition intoInstance: instance
	].
	^ instance
]

{ #category : #'as yet unclassified' }
SysmelAbstractAggregateLayout >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition intoInstance: instance [
	slots do: [ :each |
		each offset >= readSize ifTrue: [ ^ instance ].
		each readBytesFrom: aByteArray position: byteArrayPosition intoInstance: instance
	].
	^ instance
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> slots [
	^ slots
]

{ #category : #accessing }
SysmelAbstractAggregateLayout >> slots: anObject [
	slots := anObject
]

{ #category : #'as yet unclassified' }
SysmelAbstractAggregateLayout >> storeInstance: instance bytesIn: aByteArray position: byteArrayPosition [
	slots do: [ :each |
		each storeInstance: instance bytesIn: aByteArray position: byteArrayPosition
	].
	^ aByteArray
]
