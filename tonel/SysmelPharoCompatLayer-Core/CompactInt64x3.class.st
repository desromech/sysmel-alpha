Class {
	#name : #CompactInt64x3,
	#superclass : #SysmelPrimitiveCompactVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
CompactInt64x3 class >> elementType [
	^ Int64
]

{ #category : #'as yet unclassified' }
CompactInt64x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == Int64x3 ifTrue: [ ^ aValue asCompactInt64x3 ].
	^ super validateImplicitCastOfValue: aValue
]

{ #category : #converting }
CompactInt64x3 >> asCompactInt64x3 [
	^ self
]
