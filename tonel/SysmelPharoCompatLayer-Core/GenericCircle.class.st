Class {
	#name : #GenericCircle,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'center',
		'radius'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #testing }
GenericCircle class >> isAbstract [
	^ self == GenericSphere
]

{ #category : #'as yet unclassified' }
GenericCircle class >> typeOfGenericSlotNamed: slotName [
	slotName = #center ifTrue: [ ^ self vector2Type ].
	slotName = #radius ifTrue: [ ^ self scalarType ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #accessing }
GenericCircle >> center [
	^ center
]

{ #category : #accessing }
GenericCircle >> center: anObject [
	center := anObject implicitCastTo: self class vector2Type
]

{ #category : #accessing }
GenericCircle >> radius [
	^ radius
]

{ #category : #accessing }
GenericCircle >> radius: anObject [
	radius := anObject implicitCastTo: self class scalarType
]
