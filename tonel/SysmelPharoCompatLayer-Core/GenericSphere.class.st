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

{ #category : #accessing }
GenericSphere >> center [
	^ center
]

{ #category : #accessing }
GenericSphere >> center: anObject [
	center := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericSphere >> radius [
	^ radius
]

{ #category : #accessing }
GenericSphere >> radius: anObject [
	radius := anObject implicitCastTo: self class scalarType
]
