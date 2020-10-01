Class {
	#name : #CompactFloat64x3,
	#superclass : #SysmelPrimitiveCompactVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
CompactFloat64x3 class >> elementType [
	^ Float64
]

{ #category : #'as yet unclassified' }
CompactFloat64x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == Float64x3 ifTrue: [ ^ self x: aValue x y: aValue y z: aValue z ].
	^ super validateImplicitCastOfValue: aValue
]
