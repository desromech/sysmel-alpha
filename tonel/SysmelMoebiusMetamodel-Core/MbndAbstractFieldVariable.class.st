Class {
	#name : #MbndAbstractFieldVariable,
	#superclass : #MbndAbstractVariable,
	#instVars : [
		'type',
		'initialValueNode',
		'initialValueScope',
		'byteOffset',
		'slotIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #accessing }
MbndAbstractFieldVariable >> bits [
	^ nil
]

{ #category : #accessing }
MbndAbstractFieldVariable >> byteOffset [
	^ byteOffset
]

{ #category : #accessing }
MbndAbstractFieldVariable >> byteOffset: anObject [
	byteOffset := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueNode [
	^ initialValueNode
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueNode: anObject [
	initialValueNode := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueScope [
	^ initialValueScope
]

{ #category : #accessing }
MbndAbstractFieldVariable >> initialValueScope: anObject [
	initialValueScope := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
MbndAbstractFieldVariable >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #accessing }
MbndAbstractFieldVariable >> type [
	^ type
]

{ #category : #accessing }
MbndAbstractFieldVariable >> type: anObject [
	type := anObject
]
