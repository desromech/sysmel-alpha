Class {
	#name : #SysmelArrayType,
	#superclass : #SysmelAggregateType,
	#classInstVars : [
		'elements',
		'elementType',
		'instanceSize'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelArrayType class >> elementType [
	^ elementType
]

{ #category : #accessing }
SysmelArrayType class >> elements [
	^ elements
]

{ #category : #private }
SysmelArrayType class >> initializeFor: newElementType elements: newElements [
	elementType := newElementType.
	elements := newElements.
]

{ #category : #sizes }
SysmelArrayType class >> instanceAlignment [
	^ elementType instanceAlignment
]

{ #category : #accessing }
SysmelArrayType class >> instanceFor: newElementType elements: newElements [
	^ self newAnonymousSubclass
		initializeFor: newElementType elements: newElements
]

{ #category : #sizes }
SysmelArrayType class >> instanceSize [
	^ instanceSize ifNil: [ instanceSize := elementType alignedInstanceSize * elements ]
]

{ #category : #testing }
SysmelArrayType class >> isAbstract [
	^ self == SysmelArrayType
]

{ #category : #testing }
SysmelArrayType class >> isArrayType [
	^ true
]

{ #category : #printing }
SysmelArrayType class >> printOn: aStream [
	self == SysmelArrayType ifTrue: [ ^ super printOn: aStream ].
	elements = 0 ifTrue: [ 
		aStream print: elementType; nextPutAll: ' array'.
	] ifFalse: [ 
		aStream nextPut: $(; print: elementType; nextPutAll: ' array: '; print: elements; nextPut: $).
	].

]
