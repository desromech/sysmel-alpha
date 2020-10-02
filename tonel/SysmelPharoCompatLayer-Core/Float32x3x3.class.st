Class {
	#name : #Float32x3x3,
	#superclass : #SysmelPrimitiveMatrix3x3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float32x3x3 class >> elementType [
	^ Float32
]

{ #category : #converting }
Float32x3x3 >> asFloat32x3x3 [
	^ self
]
