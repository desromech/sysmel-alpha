Class {
	#name : #MbndArrayType,
	#superclass : #MbndAggregateType,
	#instVars : [
		'elementType',
		'elements',
		'instanceSize'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndArrayType class >> typeName [
	^ #_ArrayType
]

{ #category : #visiting }
MbndArrayType >> accept: aVisitor [
	^ aVisitor visitArrayType: self
]

{ #category : #accessing }
MbndArrayType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndArrayType >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndArrayType >> elements [
	^ elements
]

{ #category : #accessing }
MbndArrayType >> elements: anObject [
	elements := anObject
]

{ #category : #sizes }
MbndArrayType >> instanceAlignment [
	^ elementType instanceAlignment
]

{ #category : #sizes }
MbndArrayType >> instanceSize [
	instanceSize ifNil: [ 
		instanceSize := elements = 0
			ifTrue: [0]
			ifFalse: [ elementType alignedInstanceSize * elements]
	].

	^ instanceSize
]

{ #category : #testing }
MbndArrayType >> isArrayType [
	^ true
]
