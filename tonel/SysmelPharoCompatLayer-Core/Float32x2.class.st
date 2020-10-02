Class {
	#name : #Float32x2,
	#superclass : #SysmelPrimitiveVector2Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float32x2 class >> elementType [
	^ Float32
]

{ #category : #converting }
Float32x2 >> asFloat32x2 [
	^ self
]
