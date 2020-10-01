Class {
	#name : #UInt16x4,
	#superclass : #SysmelPrimitiveVector4Type,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #converting }
UInt16x4 class >> asWodenVertexFormat [
	^ #ushort4
]

{ #category : #accessing }
UInt16x4 class >> elementType [
	^ UInt16
]
