Class {
	#name : #ReversibleAffineTransform3dF64,
	#superclass : #GenericReversibleAffineTransform3d,
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #accessing }
ReversibleAffineTransform3dF64 class >> scalarType [
	^ Float64
]

{ #category : #converting }
ReversibleAffineTransform3dF64 >> asReversibleAffineTransform3dF64 [
	^ self
]
