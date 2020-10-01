Class {
	#name : #Boolean8,
	#superclass : #SysmelPrimitiveBooleanType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Boolean8 class >> instanceAlignment [
	^ 1
]

{ #category : #sizes }
Boolean8 class >> instanceSize [
	^ 1
]

{ #category : #'as yet unclassified' }
Boolean8 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ (aByteArray byteAt: byteArrayPosition) ~= 0
]

{ #category : #'as yet unclassified' }
Boolean8 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray byteAt: byteArrayPosition put: value asBit
]
