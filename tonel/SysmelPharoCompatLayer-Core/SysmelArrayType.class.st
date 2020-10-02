Class {
	#name : #SysmelArrayType,
	#superclass : #SysmelAggregateType,
	#instVars : [
		'storage'
	],
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

{ #category : #accessing }
SysmelArrayType >> at: index [
	^ storage at: index
]

{ #category : #accessing }
SysmelArrayType >> at: index put: value [
	^ storage at: index put: (value implicitCastTo: self class elementType)
]

{ #category : #enumerating }
SysmelArrayType >> do: aBlock [
	^ storage do: aBlock
]

{ #category : #accessing }
SysmelArrayType >> elementSize [
	^ self class elementType alignedInstanceSize
]

{ #category : #initialization }
SysmelArrayType >> initialize [
	| elementType |
	elementType := self class elementType.
	storage := (1 to: self class elements) collect: [ :i | elementType new ].
]

{ #category : #'memory access' }
SysmelArrayType >> readBytesFrom: aByteArray position: byteArrayPosition [
	| elementCount elementType elementSize sourcePosition |
	elementCount := self class elements.
	elementType := self class elementType.
	elementSize := elementType alignedInstanceSize.
	storage := Array new: elementCount.
	
	sourcePosition := byteArrayPosition.
	1 to: elementCount do: [ :i |
		storage at: i put: (elementType newFromBytes: aByteArray position: sourcePosition).
		sourcePosition := sourcePosition + elementSize
	].
]

{ #category : #accessing }
SysmelArrayType >> size [
	^ self class elements
]

{ #category : #'memory access' }
SysmelArrayType >> storeBytesIn: aByteArray position: byteArrayPosition [
	| elementSize destIndex |
	elementSize := self class elementType alignedInstanceSize.
	destIndex := byteArrayPosition.
	storage do: [ :each |
		each storeBytesIn: aByteArray position: destIndex.
		destIndex := destIndex + elementSize
	]
]
