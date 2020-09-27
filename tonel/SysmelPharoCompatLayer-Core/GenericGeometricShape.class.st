Class {
	#name : #GenericGeometricShape,
	#superclass : #GenericLinearAlgebra,
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #testing }
GenericGeometricShape class >> isAbstract [
	^ self == GenericGeometricShape
]
