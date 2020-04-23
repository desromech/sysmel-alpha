Class {
	#name : #MbndAssociationType,
	#superclass : #MbndSpecialStructureType,
	#instVars : [
		'keyType',
		'valueType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAssociationType class >> typeName [
	^ #_AssociationType
]

{ #category : #visiting }
MbndAssociationType >> accept: aVisitor [
	^ aVisitor visitAssociationType: self
]

{ #category : #initialization }
MbndAssociationType >> addFields [
	self assert: keyType isNotNil.
	self assert: valueType isNotNil.
	
	self addField: (MbndFieldVariable new
		name: #key;
		flags: #(public);
		valueType: keyType;
		type: keyType ref;
		yourself).
	self addField: (MbndFieldVariable new
		name: #value;
		flags: #(public);
		valueType: valueType;
		type: valueType ref;
		yourself).

]

{ #category : #'as yet unclassified' }
MbndAssociationType >> correctAssociationTypeForNode: node withAnalyzer: analyzer [
	^ node
]

{ #category : #'testing methods' }
MbndAssociationType >> isAssociationType [
	^ true
]

{ #category : #testing }
MbndAssociationType >> isTrait [
	^ keyType isNil
]

{ #category : #accessing }
MbndAssociationType >> keyType [
	^ keyType
]

{ #category : #accessing }
MbndAssociationType >> keyType: anObject [
	keyType := anObject
]

{ #category : #printing }
MbndAssociationType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	aStream nextPut: $(.
	keyType printOn: aStream.
	aStream nextPutAll: ' --> '.
	valueType printOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
MbndAssociationType >> valueType [
	^ valueType
]

{ #category : #accessing }
MbndAssociationType >> valueType: anObject [
	valueType := anObject
]
