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
		valueType: self elementPointerType;
		type: self elementPointerType ref;
		yourself).
	self addField: (MbndFieldVariable new
		name: #size;
		flags: #(public);
		valueType: sizeType;
		type: sizeType ref;
		yourself).

]

{ #category : #initialization }
MbndArraySliceType >> addInstanceMacros [
	self class == MbndArraySliceType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder arraySlice: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder arraySlice: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		]
]

{ #category : #converting }
MbndArraySliceType >> asImmutableValueType [
	^ self
]

{ #category : #initialization }
MbndArraySliceType >> elementPointerType [
	^ elementType pointer
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

{ #category : #printing }
MbndArraySliceType >> qualifiedName [
	^ self asString
]
