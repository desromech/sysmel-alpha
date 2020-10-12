Class {
	#name : #Float32x3,
	#superclass : #SysmelPrimitiveVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float32x3 class >> elementType [
	^ Float32
]

{ #category : #'as yet unclassified' }
Float32x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == CompactFloat32x3 ifTrue: [ ^ aValue asFloat32x3 ].
	^ super validateImplicitCastOfValue: aValue
]

{ #category : #converting }
Float32x3 >> asColor [
	^ Color r: x encodeSRGBComponent g: y encodeSRGBComponent b: z encodeSRGBComponent
]

{ #category : #converting }
Float32x3 >> asCompactFloat32x3 [
	^ CompactFloat32x3 x: x y: y z: z
]

{ #category : #converting }
Float32x3 >> asFloat32x3 [
	^ self
]

{ #category : #converting }
Float32x3 >> asFloat64x3 [
	^ Float64x3 x: x y: y z: z
]
