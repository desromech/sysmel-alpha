Class {
	#name : #Float64x4,
	#superclass : #SysmelPrimitiveVector4Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float64x4 class >> elementType [
	^ Float64
]

{ #category : #converting }
Float64x4 >> asColor [
	^ Color r: x encodeSRGBComponent g: y encodeSRGBComponent b: z encodeSRGBComponent alpha: w
]

{ #category : #converting }
Float64x4 >> asFloat64x4 [
	^ self
]
