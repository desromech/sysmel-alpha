Class {
	#name : #MbndArraySliceType,
	#superclass : #MbndSpecialStructureType,
	#instVars : [
		'elementType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArraySliceType class >> typeName [
	^ #_ArraySliceType
]

{ #category : #visiting }
MbndArraySliceType >> accept: aVisitor [
	^ aVisitor visitArraySliceType: self
]

{ #category : #initialization }
MbndArraySliceType >> addFields [
	| sizeType |
	self assert: elementType isNotNil.
	
	sizeType := self compilationTarget uintPointerType.
	self addField: (MbndFieldVariable new
		name: #elements;
		flags: #(public);
		valueType: elementType pointer;
		type: elementType pointer ref;
		yourself).
	self addField: (MbndFieldVariable new
		name: #size;
		flags: #(public);
		valueType: sizeType;
		type: sizeType ref;
		yourself).

]

{ #category : #converting }
MbndArraySliceType >> asImmutableValueType [
	^ self
]

{ #category : #accessing }
MbndArraySliceType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndArraySliceType >> elementType: anObject [
	elementType := anObject
]

{ #category : #testing }
MbndArraySliceType >> isArraySliceType [
	^ true
]

{ #category : #testing }
MbndArraySliceType >> isTrait [
	^ elementType isNil
]

{ #category : #'as yet unclassified' }
MbndArraySliceType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	elementType printOn: aStream.
	aStream nextPutAll: ' arraySlice'.

]
