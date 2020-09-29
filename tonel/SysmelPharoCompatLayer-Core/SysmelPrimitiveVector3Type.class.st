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

{ #category : #'instance creation' }
SysmelPrimitiveVector3Type class >> withAll: element [
	^ self x: element y: element z: element
]

{ #category : #construction }
SysmelPrimitiveVector3Type class >> x: x y: y z: z [
	^ self basicNew
		x: x;
		y: y;
		z: z;
		yourself
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
	^ x
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> x: anObject [
	x := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> y [
	^ y
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> y: anObject [
	y := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> z [
	^ z
]

{ #category : #accessing }
SysmelPrimitiveVector3Type >> z: anObject [
	z := anObject implicitCastTo: self class elementType
]

{ #category : #comparing }
SysmelPrimitiveVector3Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x ~= coercedOther x or: [ y ~= coercedOther y or: [ z ~= coercedOther z ]]
]
