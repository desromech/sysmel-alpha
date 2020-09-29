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

{ #category : #accessing }
SysmelPrimitiveVector4Type class >> minorVectorType [
	^ minorVectorType ifNil: [ minorVectorType := self elementType primitiveVectorWithElements: 3]
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

{ #category : #comparing }
SysmelPrimitiveVector4Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x ~= coercedOther x or: [ y ~= coercedOther y or: [ z ~= coercedOther z or: [ w ~= coercedOther w]]]
]
