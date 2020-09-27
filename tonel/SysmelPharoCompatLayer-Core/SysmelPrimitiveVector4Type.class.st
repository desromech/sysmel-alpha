Class {
	#name : #SysmelPrimitiveVector4Type,
	#superclass : #SysmelPrimitiveVectorType,
	#instVars : [
		'x',
		'y',
		'z',
		'w'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector4Type class >> elements [
	^ 4
]

{ #category : #'instance creation' }
SysmelPrimitiveVector4Type class >> withAll: element [
	^ self x: element y: element z: element w: element
]

{ #category : #constructing }
SysmelPrimitiveVector4Type class >> x: x y: y z: z w: w [
	^ self basicNew
		x: x;
		y: y;
		z: z;
		w: w;
		yourself
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

{ #category : #printing }
SysmelPrimitiveVector4Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll:  ' x: '; print: x;
		nextPutAll:  ' y: '; print: y;
		nextPutAll:  ' z: '; print: z;
		nextPutAll:  ' w: '; print: w;
		nextPut: $)
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> w [
	^ w
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> w: anObject [
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

{ #category : #accessing }
SysmelPrimitiveVector4Type >> x [
	^ x
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> x: anObject [
	x := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> y [
	^ y
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> y: anObject [
	y := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> z [
	^ z
]

{ #category : #accessing }
SysmelPrimitiveVector4Type >> z: anObject [
	z := anObject implicitCastTo: self class elementType
]
