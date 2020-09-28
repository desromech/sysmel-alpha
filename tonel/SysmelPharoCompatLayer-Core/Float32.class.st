Class {
	#name : #Float32,
	#superclass : #SysmelPrimitiveFloatType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #sizes }
Float32 class >> instanceAlignment [
	^ 4
]

{ #category : #sizes }
Float32 class >> instanceSize [
	^ 4
]

{ #category : #'as yet unclassified' }
Float32 class >> shortCapitalTypeSuffix [
	^ #F32
]
