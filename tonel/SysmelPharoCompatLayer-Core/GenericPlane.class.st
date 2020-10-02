Class {
	#name : #GenericPlane,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'normal',
		'distance'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #testing }
GenericPlane class >> isAbstract [
	^ self == GenericPlane
]

{ #category : #constructing }
GenericPlane class >> normal: normal distance: distance [
	^ self basicNew
		normal: normal;
		distance: distance;
		yourself
]

{ #category : #constructing }
GenericPlane class >> point: firstPoint point: secondPoint point: thirdPoint [
	| u v n d |
	u := secondPoint - firstPoint.
	v := thirdPoint - firstPoint.
	n := (u cross: v) normalized.
	d := n dot: firstPoint.
	^ self normal: n distance: d
]

{ #category : #'as yet unclassified' }
GenericPlane class >> typeOfGenericSlotNamed: slotName [
	slotName = #normal ifTrue: [ ^ self vector3Type ].
	slotName = #distance ifTrue: [ ^ self scalarType ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #accessing }
GenericPlane >> distance [
	^ distance
]

{ #category : #accessing }
GenericPlane >> distance: anObject [
	distance := anObject implicitCastTo: self class scalarType
]

{ #category : #initialization }
GenericPlane >> initialize [
	normal := self class vector3Type zeros.
	self distance: 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> isBehind: point [
	^ (self pointDistance: point) < 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> isInFront: point [
	^ (self pointDistance: point) > 0
]

{ #category : #accessing }
GenericPlane >> normal [
	^ normal
]

{ #category : #accessing }
GenericPlane >> normal: anObject [
	normal := anObject implicitCastTo: self class vector3Type
]

{ #category : #'as yet unclassified' }
GenericPlane >> pointDistance: point [
	^ (normal dot: point) - distance
]
