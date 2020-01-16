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

{ #category : #initialization }
MbndSimpleMetaType >> addInstanceMacros [
	self class == MbndSimpleMetaType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelectors: #( definition: extend: )do: [ :node :builder |
			builder programEntity: node receiver extension: node arguments first
		]
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'.
]
