Class {
	#name : #Int8,
	#superclass : #SysmelPrimitiveSignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Int8 class >> instanceAlignment [
	^ 1
]

{ #category : #sizes }
Int8 class >> instanceSize [
	^ 1
]

{ #category : #'as yet unclassified' }
Int8 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray signedByteAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
Int8 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray signedByteAt: byteArrayPosition put: value
]
