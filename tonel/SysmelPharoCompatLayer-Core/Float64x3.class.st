Class {
	#name : #Float64x3,
	#superclass : #SysmelPrimitiveVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Float64x3 class >> elementType [
	^ Float64
]

{ #category : #'as yet unclassified' }
Float64x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == CompactFloat64x3 ifTrue: [ ^ self x: aValue x y: aValue y z: aValue z ].
	^ super validateImplicitCastOfValue: aValue
]

{ #category : #converting }
Float64x3 >> asColor [
	^ Color r: x encodeSRGBComponent g: y encodeSRGBComponent b: z encodeSRGBComponent
]

{ #category : #converting }
Float64x3 >> asFloat32x3 [
	^ Float32x3 x: x y: y z: z
]

{ #category : #converting }
Float64x3 >> asFloat64x3 [
	^ self
]
