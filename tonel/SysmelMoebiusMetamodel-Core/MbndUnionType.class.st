Class {
	#name : #MbndUnionType,
	#superclass : #MbndAggregateTypeWithFields,
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

{ #category : #layout }
MbndUnionType >> buildSlotLayout [
	| builder |
	builder := MbndUnionSlotLayoutBuilder new.
	self buildSlotLayoutWith: builder.
	slotLayout := builder finish.
]

{ #category : #'testing methods' }
MbndUnionType >> isUnionType [
	^ true
]
