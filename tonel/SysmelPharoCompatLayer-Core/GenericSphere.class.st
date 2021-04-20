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
