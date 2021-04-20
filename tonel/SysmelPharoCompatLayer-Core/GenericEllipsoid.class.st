Class {
	#name : #GenericEllipsoid,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'center',
		'radiuses'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #testing }
GenericEllipsoid class >> isAbstract [
	^ self == GenericEllipsoid
]

{ #category : #testing }
GenericEllipsoid class >> typeOfGenericSlotNamed: slotName [
	slotName = #center ifTrue: [ ^ self vector3Type ].
	slotName = #radiuses ifTrue: [ ^ self vector3Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #comparing }
GenericEllipsoid >> = other [
	^ self class == other class and: [center = other center and: [ radiuses = other radiuses ]]
]

{ #category : #accessing }
GenericEllipsoid >> center [

	^ center
]

{ #category : #accessing }
GenericEllipsoid >> center: anObject [
	center := anObject implicitCastTo: self class vector3Type
]

{ #category : #comparing }
GenericEllipsoid >> hash [
	^ center hash bitXor: radiuses hash
]

{ #category : #accessing }
GenericEllipsoid >> radiuses [

	^ radiuses
]

{ #category : #accessing }
GenericEllipsoid >> radiuses: anObject [
	radiuses := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericEllipsoid >> support: direction [
	^ direction normalized * radiuses + center
]
