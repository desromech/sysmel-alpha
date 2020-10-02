Class {
	#name : #Int32,
	#superclass : #SysmelPrimitiveSignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Int32 class >> instanceAlignment [
	^ 4
]

{ #category : #sizes }
Int32 class >> instanceSize [
	^ 4
]

{ #category : #'as yet unclassified' }
Int32 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray signedLongAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
Int32 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray signedLongAt: byteArrayPosition put: value
]
