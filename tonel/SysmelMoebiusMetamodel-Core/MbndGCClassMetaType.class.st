Class {
	#name : #MbndGCClassMetaType,
	#superclass : #MbndGCClassType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndGCClassMetaType class >> typeName [
	^ #_GCClassMetaType
]

{ #category : #converting }
MbndGCClassMetaType >> fillProgramEntityInfoInstance: typeInfoInstance [
	super fillProgramEntityInfoInstance: typeInfoInstance.
	typeInfoInstance setField: #thisClass ifExistsWith: [ instanceType ]
]

{ #category : #accessing }
MbndGCClassMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #accessing }
MbndGCClassMetaType >> metaTypeTypeChangedFrom: oldType into: newType [
	newType markAsMetaTypeType.

	self flag: 'TODO: Recreate the meta type slots according to the new type.'.

]

{ #category : #accessing }
MbndGCClassMetaType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' class'.
]

{ #category : #accessing }
MbndGCClassMetaType >> type: newType [
	(type isNotNil and: [ type ~~ newType ]) ifTrue: [
		self metaTypeTypeChangedFrom: type into: newType
	].
	type := newType
]
