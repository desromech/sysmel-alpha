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

{ #category : #enumerating }
SysmelPrimitiveVector3Type >> collect: aBlock [
	^ self class basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		z: (aBlock value: z);
		yourself
]

{ #category : #arithmetic }
SysmelPrimitiveVector3Type >> dot: other [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ (x*castedOther x) + (y*castedOther y) + (z*castedOther z)
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
