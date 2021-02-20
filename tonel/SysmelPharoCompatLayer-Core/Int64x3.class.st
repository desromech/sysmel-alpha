Class {
	#name : #Int64x3,
	#superclass : #SysmelPrimitiveVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Int64x3 class >> elementType [
	^ Int64
]

{ #category : #converting }
Int64x3 >> asCompactInt64x3 [
	^ CompactInt64x3 x: x y: y z: z
]
