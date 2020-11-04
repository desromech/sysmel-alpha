Class {
	#name : #SysmelPrimitiveVector3Type,
	#superclass : #SysmelPrimitiveVectorType,
	#instVars : [
		'x',
		'y',
		'z'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector3Type class >> elements [
	^ 3
]

{ #category : #sizes }
SysmelPrimitiveVector3Type class >> instanceAlignment [
	^ self elementType instanceSize * 4
]

{ #category : #testing }
SysmelPrimitiveVector3Type class >> isAbstract [
	^ self == SysmelPrimitiveVector3Type
]

{ #category : #serialization }
SysmelPrimitiveVector3Type class >> loadFromJson: jsonData [
	^ self x: (jsonData at: 1) y: (jsonData at: 2) z: (jsonData at: 3)
]

{ #category : #'instance creation' }
SysmelPrimitiveVector3Type class >> withAll: element [
	^ self x: element y: element z: element
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveVector3Type class >> x: x [
	<constructor>
	^ self x: x y: 0 z: 0
]

{ #category : #construction }
SysmelPrimitiveVector3Type class >> x: x y: y [
	<constructor>
	^ self basicNew
		x: x;
		y: y;
		z: 0;
		yourself
]

{ #category : #construction }
SysmelPrimitiveVector3Type class >> x: x y: y z: z [
	<constructor>
	^ self basicNew
		x: x;
		y: y;
		z: z;
		yourself
]

{ #category : #construction }
SysmelPrimitiveVector3Type class >> xy: xy z: z [
	<constructor>
	^ self basicNew
		x: xy x;
		y: xy y;
		z: z;
		yourself
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveVector3Type class >> y: y [
	<constructor>
	^ self x: 0 y: y z: 0
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveVector3Type class >> z: z [
	<constructor>
	^ self x: 0 y: 0 z: z
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> <=> other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	x ~= coercedOther x ifTrue: [ ^ x <=> coercedOther x ].
	y ~= coercedOther y ifTrue: [ ^ y <=> coercedOther y ].
	^ z <=> coercedOther z
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x = coercedOther x and: [ y = coercedOther y and: [ z = coercedOther z ]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVector3Type >> anyOrthogonalVector [
	"Method from: https://stackoverflow.com/questions/1171849/finding-quaternion-representing-the-rotation-from-one-vector-to-another"
	| ax ay az other |
	ax := x abs.
	ay := y abs.
	az := z abs.
	other := ax < ay ifTrue: [
		ax < az
			ifTrue: [ self class x: 1.0 ]
			ifFalse: [ self class z: 1.0 ]
	] ifFalse: [ 
		ay < az
			ifTrue: [ self class y: 1.0 ]
			ifFalse: [ self class z: 1.0 ]
	].
	^ self cross: other
]

{ #category : #converting }
SysmelPrimitiveVector3Type >> asVector3 [
	^ self
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x) and: [
	  (y closeTo: coercedOther y) and: [
		z closeTo: coercedOther z ]]
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x precision: precision) and: [
	  (y closeTo: coercedOther y precision: precision) and: [
		z closeTo: coercedOther z precision: precision ]]
]

{ #category : #enumerating }
SysmelPrimitiveVector3Type >> collect: aBlock [
	^ self class basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		z: (aBlock value: z);
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveVector3Type >> collect: aBlock as: resultType [
	^ resultType basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		z: (aBlock value: z);
		yourself
]

{ #category : #arithmetic }
SysmelPrimitiveVector3Type >> cross: other [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		x: (y*castedOther z) - (z * castedOther y);
		y: (z*castedOther x) - (x * castedOther z);
		z: (x*castedOther y) - (y * castedOther x);
		yourself
]

{ #category : #arithmetic }
SysmelPrimitiveVector3Type >> dot: other [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ (x*castedOther x) + (y*castedOther y) + (z*castedOther z)
]

{ #category : #serialization }
SysmelPrimitiveVector3Type >> encodeForJSON [
	^ { x . y . z }
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> hash [
	^ (x hash hashMultiply + y hash) hashMultiply + z hash
]

{ #category : #printing }
SysmelPrimitiveVector3Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll:  ' x: '; print: x;
		nextPutAll:  ' y: '; print: y;
		nextPutAll:  ' z: '; print: z;
		nextPut: $)
]

{ #category : #'memory access' }
SysmelPrimitiveVector3Type >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	| elementType elementTypeSize |
	elementType := self class elementType.
	elementTypeSize := elementType instanceSize.
	x := elementType newFromBytes: aByteArray position: byteArrayPosition.
	y := elementType newFromBytes: aByteArray position: byteArrayPosition + elementTypeSize.
	z := elementType newFromBytes: aByteArray position: byteArrayPosition + (elementTypeSize*2).
]

{ #category : #'memory access' }
SysmelPrimitiveVector3Type >> storeBytesIn: aByteArray position: byteArrayPosition [
	| elementType elementTypeSize |
	elementType := self class elementType.
	elementTypeSize := elementType instanceSize.
	elementType storeValue: x bytesIn: aByteArray position: byteArrayPosition.
	elementType storeValue: y bytesIn: aByteArray position: byteArrayPosition + elementTypeSize.
	elementType storeValue: z bytesIn: aByteArray position: byteArrayPosition + (elementTypeSize*2).
]

{ #category : #enumerating }
SysmelPrimitiveVector3Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		x: (aBlock value: x value: castedOther x);
		y: (aBlock value: y value: castedOther y);
		z: (aBlock value: z value: castedOther z);
		yourself
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> x [
	<accessor>
	^ x
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> x: anObject [
	<accessor>
	x := anObject implicitCastTo: self class elementType
]

{ #category : #'accessing structure variables' }
SysmelPrimitiveVector3Type >> xy [
	^ self class vector2Type x: x y: y
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> y [
	<accessor>
	^ y
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> y: anObject [
	<accessor>
	y := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> z [
	<accessor>
	^ z
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> z: anObject [
	<accessor>
	z := anObject implicitCastTo: self class elementType
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x ~= coercedOther x or: [ y ~= coercedOther y or: [ z ~= coercedOther z ]]
]
