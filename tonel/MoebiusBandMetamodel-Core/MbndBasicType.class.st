"
I am a MoebiusBand basic type that is not necesarily a Smalltalk Behavior.
"
Class {
	#name : #MbndBasicType,
	#superclass : #Object,
	#traits : 'TMbndBasicType',
	#classTraits : 'TMbndBasicType classTrait',
	#instVars : [
		'name'
	],
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndBasicType class >> typeName [
	^ self == MbndBasicType ifTrue: [ #AnyValue ] ifFalse: [ nil ]
]

{ #category : #accessing }
MbndBasicType >> fullName [
	^ name
]

{ #category : #initialization }
MbndBasicType >> initialize [
	super initialize.
	name := self class typeName.
]

{ #category : #accessing }
MbndBasicType >> name [
	^ name
]

{ #category : #accessing }
MbndBasicType >> name: anObject [
	name := anObject
]

{ #category : #printing }
MbndBasicType >> printOn: aStream [
	self name ifNotNil: [ :name |
		aStream nextPutAll: name
	] ifNil: [
		^ super printOn: aStream
	]
	
]
