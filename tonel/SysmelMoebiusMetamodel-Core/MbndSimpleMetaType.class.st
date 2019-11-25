Class {
	#name : #MbndSimpleMetaType,
	#superclass : #MbndBasicType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSimpleMetaType class >> typeName [
	^ #_SimpleMetaType
]

{ #category : #visiting }
MbndSimpleMetaType >> accept: aVisitor [
	^ aVisitor visitSimpleMetaType: self
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'.
]
