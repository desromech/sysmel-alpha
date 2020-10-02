Class {
	#name : #SysmelAggregateType,
	#superclass : #SysmelNativeType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelAggregateType class >> isAggregateType [
	^ true
]

{ #category : #converting }
SysmelAggregateType >> asByteArray [
	| result |
	result := ByteArray new: self class alignedInstanceSize.
	self storeBytesIn: result.
	^ result
]
