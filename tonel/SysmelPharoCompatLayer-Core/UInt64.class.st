Class {
	#name : #UInt64,
	#superclass : #SysmelPrimitiveUnsignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
UInt64 class >> instanceAlignment [
	^ 8
]

{ #category : #sizes }
UInt64 class >> instanceSize [
	^ 8
]

{ #category : #'as yet unclassified' }
UInt64 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray unsignedLongLongAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
UInt64 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray unsignedLongLongAt: byteArrayPosition put: value
]
