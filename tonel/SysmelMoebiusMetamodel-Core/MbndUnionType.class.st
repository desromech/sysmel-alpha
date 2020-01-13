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

{ #category : #'default values' }
MbndUnionType >> defaultAggregateValueAt: aPosition [
	self isDefined ifFalse: [ 
		self error: 'Cannot produce a value for incomplete type {1}.' format: { self asString } at: aPosition
	].

	^ MbndUnionTypeInstanceValue new
		type: self;
		data: (ByteArray new: self instanceSize);
		yourself
]

{ #category : #testing }
MbndUnionType >> hasTrivialBasicInitialization [
	^ true
]

{ #category : #'testing methods' }
MbndUnionType >> isTypePassedByReference [
	^ true
]

{ #category : #'testing methods' }
MbndUnionType >> isUnionType [
	^ true
]

{ #category : #layout }
MbndUnionType >> slotLayoutBuilderClass [
	^ MbndUnionSlotLayoutBuilder
]

{ #category : #'as yet unclassified' }
MbndUnionType >> unmangledStructureTypePrefix [
	^ 'union.'
]
