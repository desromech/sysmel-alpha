Class {
	#name : #SysmelAggregateTypeWithFields,
	#superclass : #SysmelAggregateType,
	#classInstVars : [
		'aggregateLayout'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelAggregateTypeWithFields class >> aggregateLayout [
	^ aggregateLayout ifNil: [ aggregateLayout := self extractAggregateLayout ]
]

{ #category : #'as yet unclassified' }
SysmelAggregateTypeWithFields class >> aggregateLayoutKind [
	^ SysmelStructureAggregateLayout
]

{ #category : #accessing }
SysmelAggregateTypeWithFields class >> extractAggregateLayout [
	| slots |
	slots := self classLayout allSlots collect: [ :each | each asSysmelAggregateSlotDescription ].
	^ self aggregateLayoutKind new
		slots: slots;
		computeOffsets;
		yourself
]

{ #category : #sizes }
SysmelAggregateTypeWithFields class >> instanceAlignment [
	^ self aggregateLayout instanceAlignment
]

{ #category : #sizes }
SysmelAggregateTypeWithFields class >> instanceSize [
	^ self aggregateLayout instanceSize
]

{ #category : #testing }
SysmelAggregateTypeWithFields class >> isAggregateTypeWithFields [
	^ true
]

{ #category : #initialization }
SysmelAggregateTypeWithFields >> initialize [
	self class aggregateLayout initializeInstance: self.
]

{ #category : #'memory access' }
SysmelAggregateTypeWithFields >> readBytesFrom: aByteArray position: byteArrayPosition [
	^ self class aggregateLayout readBytesFrom: aByteArray position: byteArrayPosition intoInstance: self
]

{ #category : #'memory access' }
SysmelAggregateTypeWithFields >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	^ self class aggregateLayout readBytesFrom: aByteArray size: readSize position: byteArrayPosition intoInstance: self
]

{ #category : #'memory access' }
SysmelAggregateTypeWithFields >> storeBytesIn: aByteArray position: byteArrayPosition [
	self class aggregateLayout storeInstance: self bytesIn: aByteArray position: byteArrayPosition

]
