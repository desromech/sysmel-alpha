Class {
	#name : #SysmelPrimitiveVector2Type,
	#superclass : #SysmelPrimitiveVectorType,
	#instVars : [
		'x',
		'y'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector2Type class >> elements [
	^ 2
]

{ #category : #sizes }
SysmelPrimitiveVector2Type class >> instanceAlignment [
	^ self elementType instanceSize * 2
]

{ #category : #'instance creation' }
SysmelPrimitiveVector2Type class >> withAll: element [
	^ self x: element y: element
]

{ #category : #construction }
SysmelPrimitiveVector2Type class >> x: x y: y [
	^ self basicNew
		x: x;
		y: y;
		yourself
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> <=> other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	x ~= coercedOther x ifTrue: [ ^ x <=> coercedOther x ].
	^ y <=> coercedOther y
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x = coercedOther x and: [ y = coercedOther y ]
]

{ #category : #converting }
SysmelPrimitiveVector2Type >> asVector3 [
	^ (self class elementType primitiveVectorWithElements: 3)
		x: x y: y z: 0
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x) and: [
		y closeTo: coercedOther y]
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x closeTo: coercedOther x precision: precision) and: [
		y closeTo: coercedOther y precision: precision ]
]

{ #category : #arithmetic }
SysmelPrimitiveVector2Type >> collect: aBlock [
	^ self class basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		yourself
]

{ #category : #arithmetic }
SysmelPrimitiveVector2Type >> collect: aBlock as: resultType [
	^ resultType basicNew
		x: (aBlock value: x);
		y: (aBlock value: y);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVector2Type >> cross: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (x * coercedOther y) - (y * coercedOther x)
]

{ #category : #arithmetic }
SysmelPrimitiveVector2Type >> dot: other [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ (x*castedOther x) + (y*castedOther y)
]

{ #category : #serialization }
SysmelPrimitiveVector2Type >> encodeForJSON [
	^ { x . y }
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> hash [
	^ x hash hashMultiply + y hash
]

{ #category : #printing }
SysmelPrimitiveVector2Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll:  ' x: '; print: x;
		nextPutAll:  ' y: '; print: y;
		nextPut: $)
]

{ #category : #arithmetic }
SysmelPrimitiveVector2Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		x: (aBlock value: x value: castedOther x);
		y: (aBlock value: y value: castedOther y);
		yourself
]

{ #category : #accessing }
SysmelPrimitiveVector2Type >> x [
	^ x
]

{ #category : #accessing }
SysmelPrimitiveVector2Type >> x: anObject [
	x := anObject implicitCastTo: self class elementType
]

{ #category : #accessing }
SysmelPrimitiveVector2Type >> y [
	^ y
]

{ #category : #accessing }
SysmelPrimitiveVector2Type >> y: anObject [
	y := anObject implicitCastTo: self class elementType
]

{ #category : #comparing }
SysmelPrimitiveVector2Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ x ~= coercedOther x or: [ y ~= coercedOther y ]
]
