Class {
	#name : #MbndSimpleMetaType,
	#superclass : #MbndBasicType,
	#instVars : [
		'instanceType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSimpleMetaType class >> typeName [
	^ #_SimpleMetaType
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #'testing methods' }
MbndSimpleMetaType >> isMetaType [
	^ true
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'.
]
