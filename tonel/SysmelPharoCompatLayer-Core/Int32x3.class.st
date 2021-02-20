Class {
	#name : #Int32x3,
	#superclass : #SysmelPrimitiveVector3Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
Int32x3 class >> elementType [
	^ Int32
]

{ #category : #converting }
Int32x3 >> asCompactInt32x3 [
	^ CompactInt32x3 x: x y: y z: z
]
