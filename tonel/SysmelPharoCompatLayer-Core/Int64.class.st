Class {
	#name : #Int64,
	#superclass : #SysmelPrimitiveSignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Int64 class >> instanceAlignment [
	^ 8
]

{ #category : #sizes }
Int64 class >> instanceSize [
	^ 8
]

{ #category : #'as yet unclassified' }
Int64 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray signedLongLongAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
Int64 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray signedLongLongAt: byteArrayPosition put: value
]
