Class {
	#name : #Float64,
	#superclass : #SysmelPrimitiveFloatType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Float64 class >> instanceAlignment [
	^ 8
]

{ #category : #sizes }
Float64 class >> instanceSize [
	^ 8
]

{ #category : #'as yet unclassified' }
Float64 class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ aByteArray doubleAt: byteArrayPosition
]

{ #category : #'as yet unclassified' }
Float64 class >> shortCapitalTypeSuffix [
	^ #F64
]

{ #category : #'as yet unclassified' }
Float64 class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	aByteArray doubleAt: byteArrayPosition put: value
]
