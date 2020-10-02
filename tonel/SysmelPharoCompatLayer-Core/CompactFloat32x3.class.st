Class {
	#name : #CompactFloat32x3,
	#superclass : #SysmelPrimitiveCompactVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
CompactFloat32x3 class >> elementType [
	^ Float32
]

{ #category : #'as yet unclassified' }
CompactFloat32x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == Float32x3 ifTrue: [ ^ aValue asCompactFloat32x3 ].
	^ super validateImplicitCastOfValue: aValue
]

{ #category : #converting }
CompactFloat32x3 >> asCompactFloat32x3 [
	^ self
]

{ #category : #converting }
CompactFloat32x3 >> asFloat32x3 [
	^ Float32x3 x: x y: y z: z
]
