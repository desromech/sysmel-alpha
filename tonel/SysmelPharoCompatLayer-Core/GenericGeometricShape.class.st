Class {
	#name : #GenericGeometricShape,
	#superclass : #GenericLinearAlgebra,
	#classInstVars : [
		'rectangleType',
		'boxType',
		'planeType',
		'frustumType',
		'ray2dType',
		'ray3dType'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #accessing }
GenericGeometricShape class >> boxType [
	^ boxType ifNil: [ boxType := self environment at: (#Box , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #accessing }
GenericGeometricShape class >> frustumType [
	^ frustumType ifNil: [ frustumType := self environment at: (#Frustum , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #testing }
GenericGeometricShape class >> isAbstract [
	^ self == GenericGeometricShape
]

{ #category : #accessing }
GenericGeometricShape class >> planeType [
	^ planeType ifNil: [ planeType := self environment at: (#Plane , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #accessing }
GenericGeometricShape class >> ray2dType [
	^ ray2dType ifNil: [ ray2dType := self environment at: (#Ray2d , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #accessing }
GenericGeometricShape class >> ray3dType [
	^ ray3dType ifNil: [ ray3dType := self environment at: (#Ray3d , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #accessing }
GenericGeometricShape class >> rectangleType [
	^ rectangleType ifNil: [ rectangleType := self environment at: (#Rectangle , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #'as yet unclassified' }
GenericGeometricShape >> distanceWithConvexShape: convexShape [
	^ GJK distanceFrom: self supportFunction to: convexShape supportFunction
]

{ #category : #'as yet unclassified' }
GenericGeometricShape >> distanceWithShape: otherShape [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GenericGeometricShape >> distanceWithSphere: sphere [
	^ self distanceWithConvexShape: sphere
]

{ #category : #accessing }
GenericGeometricShape >> support: direction [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GenericGeometricShape >> supportFunction [
	^ [ :dir | self support: dir ]
]
