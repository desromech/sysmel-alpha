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

{ #category : #serialization }
GenericPlane class >> loadFromJson: jsonData [
	^ self nx: (jsonData at: 1) ny: (jsonData at: 2) nz: (jsonData at: 3) distance: (jsonData at: 4) negated
]

{ #category : #constructing }
GenericPlane class >> normal: normal distance: distance [
	^ self basicNew
		normal: normal;
		distance: distance;
		yourself
]

{ #category : #constructing }
GenericPlane class >> normal: normal point: point [
	^ self normal: normal distance: (normal dot: point)
]

{ #category : #constructing }
GenericPlane class >> nx: nx distance: distance [
	^ self normal: (Float32x3 x: nx) distance: distance
]

{ #category : #constructing }
GenericPlane class >> nx: nx ny: ny nz: nz distance: distance [
	^ self normal: (Float32x3 x: nx y: ny z: nz) distance: distance
]

{ #category : #constructing }
GenericPlane class >> ny: ny distance: distance [
	^ self normal: (Float32x3 y: ny) distance: distance
]

{ #category : #constructing }
GenericPlane class >> nz: nz distance: distance [
	^ self normal: (Float32x3 z: nz) distance: distance
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

{ #category : #comparing }
GenericPlane >> = other [
	^ normal = other normal and: [ distance = other distance ]
]

{ #category : #comparing }
GenericPlane >> closeTo: other [
	^ (normal closeTo: other normal) and: [ distance closeTo: other distance ]
]

{ #category : #comparing }
GenericPlane >> closeTo: other precision: precision [
	^ (normal closeTo: other normal precision: precision) and: [ distance closeTo: other distance precision: precision ]
]

{ #category : #accessing }
GenericPlane >> distance [
	^ distance
]

{ #category : #accessing }
GenericPlane >> distance: anObject [
	distance := anObject implicitCastTo: self class scalarType
]

{ #category : #serialization }
GenericPlane >> encodeForJSON [
	^ { normal x . normal y . normal z . distance negated }
]

{ #category : #comparing }
GenericPlane >> hash [
	^ normal hash hashMultiply + distance hash
]

{ #category : #initialization }
GenericPlane >> initialize [
	normal := self class vector3Type zeros.
	self distance: 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> intersectionWith: secondPlane with: thirdPlane [
	| mat det |
	mat := self class matrix3x3Type rows: {
		normal . secondPlane normal . thirdPlane normal
	}.
	det := mat determinant.
	(det closeTo: 0.0) ifTrue: [ ^ nil ].
	
	^ mat inverse * (self class vector3Type x: distance y: secondPlane distance z: thirdPlane distance)
]

{ #category : #'as yet unclassified' }
GenericPlane >> intersectionWithRay: ray [
	| den t |
	den := normal dot: ray direction.
	den = 0 ifTrue: [ ^ nil ].
	t := ((distance - (normal dot: ray origin)) / den).
	(t < ray tmin or: [t > ray tmax]) ifTrue: [ ^ nil ].
	^ t
]

{ #category : #'as yet unclassified' }
GenericPlane >> isBehind: point [
	^ (self pointDistance: point) < 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> isBehindOrInside: point [
	^ (self pointDistance: point) <= 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> isInFront: point [
	^ (self pointDistance: point) > 0
]

{ #category : #'as yet unclassified' }
GenericPlane >> isInFrontOrInside: point [
	^ (self pointDistance: point) >= 0
]

{ #category : #arithmetic }
GenericPlane >> negated [
	^ self class normal: normal negated distance: distance negated
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
GenericPlane >> normalized [
	| normalLength |
	normalLength := normal length.
	normalLength = 0 ifTrue: [ ^ self ].
	^ self class normal: normal / normalLength distance: distance / normalLength
]

{ #category : #'as yet unclassified' }
GenericPlane >> pointDistance: point [
	^ (normal dot: point) - distance
]

{ #category : #printing }
GenericPlane >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll: ' normal: '; print: normal;
		nextPutAll: ' distance: '; print: distance;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GenericPlane >> transformedWithAffineMatrix: matrix [
	| planeEquation transformedPlaneEquation transformedPlane |
	planeEquation := self class vector4Type xyz: normal w: distance.
	transformedPlaneEquation := planeEquation * matrix.
	transformedPlane := self class normal: transformedPlaneEquation xyz distance: transformedPlaneEquation w.
	^ transformedPlane normalized
]
