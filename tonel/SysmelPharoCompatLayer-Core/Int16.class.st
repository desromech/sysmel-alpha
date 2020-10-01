Class {
	#name : #Int16,
	#superclass : #SysmelPrimitiveSignedIntegerType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Int16 class >> instanceAlignment [
	^ 2
]

{ #category : #sizes }
Int16 class >> instanceSize [
	^ 2
]

{ #category : #'as yet unclassified' }
Int16 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray signedShortAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
Int16 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray signedShortAt: byteArrayPosition put: value
]
