Class {
	#name : #MbndStructureType,
	#superclass : #MbndAggregateType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndStructureType class >> typeName [
	^ #_StructureType
]

{ #category : #'testing methods' }
MbndStructureType >> isStructureType [
	^ true
]
