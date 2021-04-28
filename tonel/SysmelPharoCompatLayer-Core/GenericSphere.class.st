Class {
	#name : #GenericSphere,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'center',
		'radius'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #testing }
GenericSphere class >> isAbstract [
	^ self == GenericSphere
]

{ #category : #'as yet unclassified' }
GenericSphere class >> typeOfGenericSlotNamed: slotName [
	slotName = #center ifTrue: [ ^ self vector3Type ].
	slotName = #radius ifTrue: [ ^ self scalarType ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #comparing }
GenericSphere >> = other [
	^ self class == other class and: [center = other center and: [ radius = other radius ]]
]

{ #category : #accessing }
GenericSphere >> center [
	^ center
]

{ #category : #accessing }
GenericSphere >> center: anObject [
	center := anObject implicitCastTo: self class vector3Type
]

{ #category : #'as yet unclassified' }
GenericSphere >> computeNormalForPoint: point [
	^ (point - center) normalized
]

{ #category : #'as yet unclassified' }
GenericSphere >> computePenetrationNormalAndDistanceForPoint: point [
	| vector |
	vector := point - center.
	^ {vector normalized . (vector length - radius)} abs
]

{ #category : #'as yet unclassified' }
GenericSphere >> distanceWithShape: otherShape [
	^ otherShape distanceWithSphere: self
	
]

{ #category : #'as yet unclassified' }
GenericSphere >> distanceWithSphere: sphere [
	^ (center - sphere center) length - radius - sphere radius max: 0
]

{ #category : #comparing }
GenericSphere >> hash [
	^ center hash bitXor: radius hash
]

{ #category : #'as yet unclassified' }
GenericSphere >> intersectionWithRay: ray [
	"Ray sphere intersection formula from: https://viclw17.github.io/2018/07/16/raytracing-ray-sphere-intersection/"
	| a b c delta deltaSqrt t1 t2 isT1Valid isT2Valid |
	a := ray direction dot: ray direction.
	b := 2.0 * (ray direction dot: ray origin - center).
	c := (ray origin - center) length2 - (radius*radius).
	
	delta := b*b - (4*a*c).
	delta < 0 ifTrue: [ ^ nil ].

	deltaSqrt := delta sqrt.
	t1 := (b negated - deltaSqrt) / (2*a).	
	t2 := (b negated + deltaSqrt) / (2*a).
	
	isT1Valid := t1 between: ray tmin and: ray tmax.
	isT2Valid := t2 between: ray tmin and: ray tmax.
	
	(isT1Valid and: [isT2Valid]) ifTrue: [ ^ t1 min: t2 ].
	isT1Valid ifTrue: [ ^ t1 ].
	isT2Valid ifTrue: [ ^ t2 ].
	^ nil
]

{ #category : #accessing }
GenericSphere >> radius [
	^ radius
]

{ #category : #accessing }
GenericSphere >> radius: anObject [
	radius := anObject implicitCastTo: self class scalarType
]

{ #category : #accessing }
GenericSphere >> support: direction [
	^ direction normalized * radius + center
]

{ #category : #transforming }
GenericSphere >> transformedWith: transform [
	^ self class basicNew
		center: (transform transformPosition: center);
		radius: radius * transform maxScaleFactor;
		yourself
]
