Class {
	#name : #SysmelPrimitiveVector4Type,
	#superclass : #SysmelPrimitiveVectorType,
	#instVars : [
		'x',
		'y',
		'z',
		'w'
	],
	#classInstVars : [
		'minorVectorType'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector4Type class >> elements [
	^ 4
]

{ #category : #sizes }
SysmelPrimitiveVector4Type class >> instanceAlignment [
	^ self elementType instanceSize * 4
]

{ #category : #testing }
SysmelPrimitiveVector4Type class >> isAbstract [
	^ self == SysmelPrimitiveVector4Type
]

{ #category : #serialization }
SysmelPrimitiveVector4Type class >> loadFromJson: jsonData [
	^ self x: (jsonData at: 1) y: (jsonData at: 2) z: (jsonData at: 3) w: (jsonData at: 4)
]

{ #category : #accessing }
SysmelPrimitiveVector4Type class >> minorVectorType [
	^ minorVectorType ifNil: [ minorVectorType := self elementType primitiveVectorWithElements: 3]
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> w: w [
	<constructor>
	^ self x: 0 y: 0 z: 0 w: w
]

{ #category : #'instance creation' }
SysmelPrimitiveVector4Type class >> withAll: element [
	^ self x: element y: element z: element w: element
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> x: x [
	<constructor>
	^ self x: x y: 0 z: 0 w: 0
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> x: x y: y [
	<constructor>
	^ self basicNew
		x: x;
		y: y;
		z: 0;
		w: 0;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> x: x y: y z: z [
	<constructor>
	^ self basicNew
		x: x;
		y: y;
		z: z;
		w: 0;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> x: x y: y z: z w: w [
	<constructor>
	^ self basicNew
		x: x;
		y: y;
		z: z;
		w: w;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> xy: xy zw: zw [
	<constructor>
	^ self basicNew
		x: xy x;
		y: xy y;
		z: zw x;
		w: zw y;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> xyz: xyz [
	<constructor>
	^ self basicNew
		x: xyz x;
		y: xyz y;
		z: xyz z;
		w: 0;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> xyz: xyz w: w [
	<constructor>
	^ self basicNew
		x: xyz x;
		y: xyz y;
		z: xyz z;
		w: w;
		yourself
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> y: y [
	<constructor>
	^ self x: 0 y: y z: 0 w: 0
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> z: z [
	<constructor>
	^ self x: 0 y: 0 z: z w: 0
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> <=> other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	x ~= coercedOther x ifTrue: [ ^ x <=> coercedOther x ].
	y ~= coercedOther y ifTrue: [ ^ y <=> coercedOther y ].
	z ~= coercedOther z ifTrue: [ ^ z <=> coercedOther z ].
	^ w <=> coercedOther w
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x = coercedOther x and: [ y = coercedOther y and: [ z = coercedOther z and: [ w = coercedOther w]]]
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> at: elementIndex [
	elementIndex = 1 ifTrue: [ ^ x ].
	elementIndex = 2 ifTrue: [ ^ y ].
	elementIndex = 3 ifTrue: [ ^ z ].
	elementIndex = 4 ifTrue: [ ^ w ].
	^ self error
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x) and: [
	  (y closeTo: coercedOther y) and: [
	  (z closeTo: coercedOther z) and: [
		w closeTo: coercedOther w ]]]
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x precision: precision) and: [
	  (y closeTo: coercedOther y precision: precision) and: [
	  (z closeTo: coercedOther z precision: precision) and: [
		w closeTo: coercedOther w precision: precision ]]]
]

{ #category : #enumerating }
SysmelPrimitiveVector4Type >> collect: aBlock [
	^ self class basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		z: (aBlock value: z);
		w: (aBlock value: w);
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveVector4Type >> collect: aBlock as: resultType [
	^ resultType basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		z: (aBlock value: z);
		w: (aBlock value: w);
		yourself
]

{ #category : #arithmetic }
SysmelPrimitiveVector4Type >> dot: other [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ (x*castedOther x) + (y*castedOther y) + (z*castedOther z) + (w*castedOther w)
]

{ #category : #serialization }
SysmelPrimitiveVector4Type >> encodeForJSON [
	^ { x . y . z . w }
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> hash [
	^ ((x hash hashMultiply + y hash) hashMultiply + z hash) hashMultiply + w hash
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> minorAt: index [
	index = 1 ifTrue: [ ^ self class minorVectorType x: y y: z z: w ].
	index = 2 ifTrue: [ ^ self class minorVectorType x: x y: z z: w ].
	index = 3 ifTrue: [ ^ self class minorVectorType x: x y: y z: w ].
	index = 4 ifTrue: [ ^ self class minorVectorType x: x y: y z: z ].
	self error
]

{ #category : #printing }
SysmelPrimitiveVector4Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll:  ' x: '; print: x;
		nextPutAll:  ' y: '; print: y;
		nextPutAll:  ' z: '; print: z;
		nextPutAll:  ' w: '; print: w;
		nextPut: $)
]

{ #category : #'memory access' }
SysmelPrimitiveVector4Type >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	| elementType elementTypeSize |
	elementType := self class elementType.
	elementTypeSize := elementType instanceSize.
	x := elementType newFromBytes: aByteArray position: byteArrayPosition.
	y := elementType newFromBytes: aByteArray position: byteArrayPosition + elementTypeSize.
	z := elementType newFromBytes: aByteArray position: byteArrayPosition + (elementTypeSize*2).
	w := elementType newFromBytes: aByteArray position: byteArrayPosition + (elementTypeSize*3).
]

{ #category : #'memory access' }
SysmelPrimitiveVector4Type >> storeBytesIn: aByteArray position: byteArrayPosition [
	| elementType elementTypeSize |
	elementType := self class elementType.
	elementTypeSize := elementType instanceSize.
	elementType storeValue: x bytesIn: aByteArray position: byteArrayPosition.
	elementType storeValue: y bytesIn: aByteArray position: byteArrayPosition + elementTypeSize.
	elementType storeValue: z bytesIn: aByteArray position: byteArrayPosition + (elementTypeSize*2).
	elementType storeValue: w bytesIn: aByteArray position: byteArrayPosition + (elementTypeSize*3).
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> w [
	<accessor>
	^ w
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> w: anObject [
	<accessor>
	w := anObject implicitCastTo: self class elementType
]

{ #category : #arithmetic }
SysmelPrimitiveVector4Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		x: (aBlock value: x value: castedOther x);
		y: (aBlock value: y value: castedOther y);
		z: (aBlock value: z value: castedOther z);
		w: (aBlock value: w value: castedOther w);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVector4Type >> wxyz [
	^ self class basicNew
		x: w;
		y: x;
		z: y;
		w: z;
		yourself
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> x [
	<accessor>
	^ x
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> x: anObject [
	<accessor>
	x := anObject implicitCastTo: self class elementType
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVector4Type >> xyz [
	^ self class vector3Type x: x y: y z: z
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> y [
	<accessor>
	^ y
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> y: anObject [
	<accessor>
	y := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> z [
	<accessor>
	^ z
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> z: anObject [
	<accessor>
	z := anObject implicitCastTo: self class elementType
]

{ #category : #comparing }
SysmelPrimitiveVector4Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x ~= coercedOther x or: [ y ~= coercedOther y or: [ z ~= coercedOther z or: [ w ~= coercedOther w]]]
]
