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
	builder := MbndUnionSlotLayoutBuilder new aggregate: self.
	self buildSlotLayoutWith: builder.
	slotLayout := builder finish.
]

{ #category : #'default values' }
MbndUnionType >> defaultValueAt: aPosition [
	self isDefined ifFalse: [ 
		self error: 'Cannot produce a value for incomplete type {1}.' format: { self asString } at: aPosition
	].

	^ MbndUnionTypeInstanceValue new
		type: self;
		data: (ByteArray new: self instanceSize);
		yourself
]

{ #category : #'testing methods' }
MbndUnionType >> isUnionType [
	^ true
]
