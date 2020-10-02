Class {
	#name : #Float64x3x3,
	#superclass : #SysmelPrimitiveMatrix3x3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float64x3x3 class >> elementType [
	^ Float64
]

{ #category : #converting }
Float64x3x3 >> asFloat64x3x3 [
	^ self
]
