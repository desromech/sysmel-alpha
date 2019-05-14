Class {
	#name : #MbndStructureType,
	#superclass : #MbndAggregateTypeWithFields,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndStructureType class >> typeName [
	^ #_StructureType
]

{ #category : #visiting }
MbndStructureType >> accept: aVisitor [
	^ aVisitor visitStructureType: self
]

{ #category : #'testing methods' }
MbndStructureType >> isStructureType [
	^ true
]
