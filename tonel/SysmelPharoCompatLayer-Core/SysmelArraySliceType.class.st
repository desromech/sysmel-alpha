Class {
	#name : #SysmelArraySliceType,
	#superclass : #SysmelAggregateType,
	#instVars : [
		'elements',
		'offset',
		'size'
	],
	#classInstVars : [
		'elementType'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelArraySliceType class >> elements: elements offset: offset size: size [
	^ self basicNew
		initializeWithElements: elements offset: offset size: size;
		yourself
]

{ #category : #initialization }
SysmelArraySliceType class >> initializeFor: newElementType [
	elementType := newElementType.
	name := (newElementType asString , ' arraySlice') asSymbol.
]

{ #category : #sizes }
SysmelArraySliceType class >> instanceAlignment [
	^ Smalltalk wordSize
]

{ #category : #'as yet unclassified' }
SysmelArraySliceType class >> instanceFor: newElementType [
	^ self newAnonymousSubclass
		initializeFor: newElementType
]

{ #category : #sizes }
SysmelArraySliceType class >> instanceSize [
	^ Smalltalk wordSize * 2
]

{ #category : #testing }
SysmelArraySliceType class >> isAbstract [
	^ self == SysmelArraySliceType
]

{ #category : #testing }
SysmelArraySliceType class >> isArraySliceType [
	^ true
]

{ #category : #converting }
SysmelArraySliceType >> asByteArray [
	^ ByteArray new: self class instanceSize
]

{ #category : #accessing }
SysmelArraySliceType >> at: index [
	(index < 1 or: [index > size]) ifTrue: [ ^ self errorSubscriptBounds: index ].
	^ elements at: index
]

{ #category : #accessing }
SysmelArraySliceType >> at: index put: anElement [
	(index < 1 or: [index > size]) ifTrue: [ ^ self errorSubscriptBounds: index ].
	^ elements at: index put: (anElement implicitCastTo: self class elementType)
]

{ #category : #accessing }
SysmelArraySliceType >> elements [
	^ elements
]

{ #category : #accessing }
SysmelArraySliceType >> initializeWithElements: anObject offset: anOffset size: aSize [
	elements := anObject.
	offset := anOffset.
	size := aSize.
]

{ #category : #accessing }
SysmelArraySliceType >> offset [
	^ offset
]

{ #category : #'memory access' }
SysmelArraySliceType >> readBytesFrom: aByteArray position: byteArrayPosition [
	"nop"
]

{ #category : #accessing }
SysmelArraySliceType >> size [
	^ size
]

{ #category : #'memory access' }
SysmelArraySliceType >> storeBytesIn: aByteArray position: byteArrayPosition [
	"nop"
]
