Class {
	#name : #GenericGeometricShape,
	#superclass : #GenericLinearAlgebra,
	#classInstVars : [
		'rectangleType',
		'boxType'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #accessing }
GenericGeometricShape class >> boxType [
	^ boxType ifNil: [ boxType := self environment at: (#Box , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]

{ #category : #testing }
GenericGeometricShape class >> isAbstract [
	^ self == GenericGeometricShape
]

{ #category : #accessing }
GenericGeometricShape class >> rectangleType [
	^ rectangleType ifNil: [ rectangleType := self environment at: (#Rectangle , self scalarType shortCapitalTypeSuffix) asSymbol  ]
]
