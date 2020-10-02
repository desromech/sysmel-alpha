Class {
	#name : #UInt32,
	#superclass : #SysmelPrimitiveUnsignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
UInt32 class >> instanceAlignment [
	^ 4
]

{ #category : #sizes }
UInt32 class >> instanceSize [
	^ 4
]

{ #category : #'as yet unclassified' }
UInt32 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray unsignedLongAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
UInt32 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray unsignedLongAt: byteArrayPosition put: value
]
