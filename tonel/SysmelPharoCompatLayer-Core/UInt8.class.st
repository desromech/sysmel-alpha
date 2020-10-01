Class {
	#name : #UInt8,
	#superclass : #SysmelPrimitiveUnsignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
UInt8 class >> instanceAlignment [
	^ 1
]

{ #category : #sizes }
UInt8 class >> instanceSize [
	^ 1
]

{ #category : #'as yet unclassified' }
UInt8 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray unsignedByteAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
UInt8 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray unsignedByteAt: byteArrayPosition put: value
]
