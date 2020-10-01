Class {
	#name : #SysmelUnionType,
	#superclass : #SysmelAggregateTypeWithFields,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelUnionType class >> aggregateLayoutKind [
	^ SysmelUnionAggregateLayout
]

{ #category : #testing }
SysmelUnionType class >> isUnionType [
	^ true
]
