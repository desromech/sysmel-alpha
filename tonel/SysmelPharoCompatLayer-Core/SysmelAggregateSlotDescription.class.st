Class {
	#name : #SysmelAggregateSlotDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'instanceVariableIndex',
		'type',
		'offset',
		'location'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #initialization }
SysmelAggregateSlotDescription >> initializeInstance: instance [
	instance instVarAt: instanceVariableIndex put: type new
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> instanceVariableIndex [
	^ instanceVariableIndex
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> instanceVariableIndex: anObject [
	instanceVariableIndex := anObject
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> location [
	^ location
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> location: anObject [
	location := anObject
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> name [
	^ name
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> offset [
	^ offset
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> offset: anObject [
	offset := anObject
]

{ #category : #'as yet unclassified' }
SysmelAggregateSlotDescription >> readBytesFrom: aByteArray position: byteArrayPosition intoInstance: instance [
	instance instVarAt: instanceVariableIndex put: (type newFromBytes: aByteArray position: byteArrayPosition + offset).
]

{ #category : #'as yet unclassified' }
SysmelAggregateSlotDescription >> storeInstance: instance bytesIn: aByteArray position: byteArrayPosition [
	| value |
	value := instance instVarAt: instanceVariableIndex.
	type storeValue: value bytesIn: aByteArray position: byteArrayPosition + offset
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> type [
	^ type
]

{ #category : #accessing }
SysmelAggregateSlotDescription >> type: anObject [
	type := anObject
]
