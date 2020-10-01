Class {
	#name : #UInt16,
	#superclass : #SysmelPrimitiveUnsignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
UInt16 class >> instanceAlignment [
	^ 2
]

{ #category : #sizes }
UInt16 class >> instanceSize [
	^ 2
]

{ #category : #'as yet unclassified' }
UInt16 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray unsignedShortAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
UInt16 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray unsignedShortAt: byteArrayPosition put: value
]
