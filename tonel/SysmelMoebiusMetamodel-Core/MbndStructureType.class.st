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

{ #category : #testing }
MbndStructureType >> isPacked [
	^ self hasFlag: #packed
]

{ #category : #'testing methods' }
MbndStructureType >> isStructureType [
	^ true
]

{ #category : #layout }
MbndStructureType >> slotLayoutBuilderClass [
	self isPacked ifTrue: [ ^ MbndPackedSlotLayoutBuilder ].
	^ super slotLayoutBuilderClass
]

{ #category : #'as yet unclassified' }
MbndStructureType >> unmangledStructureTypePrefix [
	^ 'struct.'
]
