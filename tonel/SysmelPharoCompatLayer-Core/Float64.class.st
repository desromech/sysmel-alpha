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
Float64 class >> shortCapitalTypeSuffix [
	^ #F64
]
