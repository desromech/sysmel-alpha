Class {
	#name : #MbndUnionType,
	#superclass : #MbndAggregateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUnionType class >> typeName [
	^ #_UnionType
]

{ #category : #visiting }
MbndUnionType >> accept: aVisitor [
	^ aVisitor visitUnionType: self
]

{ #category : #'testing methods' }
MbndUnionType >> isUnionType [
	^ true
]
