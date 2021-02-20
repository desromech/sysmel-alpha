Class {
	#name : #CompactInt32x3,
	#superclass : #SysmelPrimitiveCompactVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
CompactInt32x3 class >> elementType [
	^ Int32
]

{ #category : #'as yet unclassified' }
CompactInt32x3 class >> validateImplicitCastOfValue: aValue [
	aValue class == Int32x3 ifTrue: [ ^ aValue asCompactInt32x3 ].
	^ super validateImplicitCastOfValue: aValue
]

{ #category : #converting }
CompactInt32x3 >> asCompactInt32x3 [
	^ self
]
