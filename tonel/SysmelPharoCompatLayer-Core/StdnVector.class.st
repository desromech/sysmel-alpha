Class {
	#name : #StdnVector,
	#superclass : #SysmelGenericStructureType,
	#instVars : [
		'storage',
		'rawData'
	],
	#classInstVars : [
		'elementType'
	],
	#category : #'SysmelPharoCompatLayer-Core-Collections'
}

{ #category : #accessing }
StdnVector class >> elementType [
	^ elementType
]

{ #category : #'instance creation' }
StdnVector class >> for: anElementType [
	self assert: self == StdnVector.
	self assert: anElementType isSysmelNativeType.
	^ SysmelNativeTypeCache getGeneric: self withArguments: anElementType orCreateWith: [
		self newAnonymousSubclass
			initializeForElementType: anElementType;
			yourself
	]
]

{ #category : #private }
StdnVector class >> initializeForElementType: theElementType [
	elementType := theElementType
]

{ #category : #testing }
StdnVector class >> isAbstract [
	^ self == StdnVector
]

{ #category : #'instance creation' }
StdnVector class >> newFor: anElementType [
	^ (self for: anElementType) new
]

{ #category : #adding }
StdnVector >> add: anElement [
	rawData := nil.
	^ storage add: (anElement implicitCastTo: self class elementType)
]

{ #category : #accessing }
StdnVector >> asByteArray [
	^ self rawData
]

{ #category : #enumerating }
StdnVector >> at: index [
	^ storage at: index
]

{ #category : #enumerating }
StdnVector >> at: index put: value [
	rawData := nil.
	^ storage at: index put: (value implicitCastTo: self class elementType)
]

{ #category : #enumerating }
StdnVector >> do: aBlock [
	^ storage do: aBlock
]

{ #category : #accessing }
StdnVector >> elementSize [
	^ self class elementType alignedInstanceSize
]

{ #category : #testing }
StdnVector >> ifEmpty: aBlock [
	^ storage ifEmpty: aBlock
]

{ #category : #testing }
StdnVector >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	^ storage ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
]

{ #category : #testing }
StdnVector >> ifNotEmpty: aBlock [
	^ storage ifNotEmpty: aBlock
]

{ #category : #testing }
StdnVector >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	^ storage ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
]

{ #category : #initialization }
StdnVector >> initialize [
	storage := OrderedCollection new.
]

{ #category : #testing }
StdnVector >> isEmpty [
	^ storage isEmpty
]

{ #category : #testing }
StdnVector >> isNotEmpty [
	^ storage isNotEmpty
]

{ #category : #accessing }
StdnVector >> rawData [
	| elementSize destIndex elementType |
	rawData ifNotNil: [ ^ rawData ].
	storage ifEmpty: [
		^ rawData := ByteArray new
	].

	elementSize := self elementSize.
	elementType := self class elementType.
	rawData := ByteArray new: elementSize * storage size.
	destIndex := 1.
	storage do: [ :each |
		elementType storeValue: each bytesIn: rawData position: destIndex.
		destIndex := destIndex + elementSize.
	].

	^ rawData
]

{ #category : #accessing }
StdnVector >> rawDataSize [
	^ self elementSize * storage size
]

{ #category : #adding }
StdnVector >> remove: anElement [
	^ storage remove: (anElement implicitCastTo: self class elementType)
]

{ #category : #removing }
StdnVector >> removeAll [
	storage removeAll.
	rawData := nil.
]

{ #category : #adding }
StdnVector >> size [
	^ storage size
]
