Class {
	#name : #MbndAssociationType,
	#superclass : #MbndAggregateType,
	#instVars : [
		'keyType',
		'valueType',
		'instanceSize',
		'instanceAlignment',
		'elementOffsets'
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

{ #category : #'testing methods' }
MbndAssociationType >> computeLayout [
	self assert: keyType isLiteralValueType not.
	self assert: valueType isLiteralValueType not.

	"Key"
	instanceSize := keyType instanceSize.
	instanceAlignment := keyType instanceAlignment.

	"Value"
	instanceSize := instanceSize alignedTo: valueType instanceAlignment.
	instanceAlignment := instanceAlignment max: valueType instanceAlignment.
	elementOffsets := { 0 . instanceSize}.
	instanceSize := instanceSize + valueType instanceSize.

	"Final alignment."
	instanceSize := instanceSize alignedTo: valueType instanceAlignment.

]

{ #category : #'as yet unclassified' }
MbndAssociationType >> correctAssociationTypeForNode: node withAnalyzer: analyzer [
	^ node
]

{ #category : #'testing methods' }
MbndAssociationType >> elementOffsets [
	elementOffsets ifNil: [ self computeLayout ].
	^ elementOffsets
]

{ #category : #sizes }
MbndAssociationType >> instanceAlignment [
	<compileTime>
	instanceAlignment ifNil: [ self computeLayout ].
	^ instanceAlignment
]

{ #category : #sizes }
MbndAssociationType >> instanceSize [
	<compileTime>
	instanceSize ifNil: [ self computeLayout ].
	^ instanceSize
]

{ #category : #'testing methods' }
MbndAssociationType >> isAssociationType [
	^ true
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
