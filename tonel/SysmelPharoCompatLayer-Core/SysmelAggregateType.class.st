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

{ #category : #'memory access' }
SysmelAggregateType >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	^ self class aggregateLayout readBytesFrom: aByteArray size: readSize position: byteArrayPosition intoInstance: self
]

{ #category : #'memory access' }
SysmelAggregateType >> storeBytesIn: aByteArray position: byteArrayPosition [
	self class aggregateLayout storeInstance: self bytesIn: aByteArray position: byteArrayPosition

]
