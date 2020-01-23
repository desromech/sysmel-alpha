Class {
	#name : #MbndIOChannelType,
	#superclass : #MbndOpaqueHandleType,
	#instVars : [
		'messageType',
		'specialSemantics'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndIOChannelType class >> typeName [
	^ #_IOChannelType
]

{ #category : #'default values' }
MbndIOChannelType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #'testing methods' }
MbndIOChannelType >> isIOChannelType [
	^ true
]

{ #category : #accessing }
MbndIOChannelType >> messageType [
	^ messageType
]

{ #category : #accessing }
MbndIOChannelType >> messageType: anObject [
	messageType := anObject
]

{ #category : #accessing }
MbndIOChannelType >> specialSemantics [
	^ specialSemantics
]

{ #category : #accessing }
MbndIOChannelType >> specialSemantics: anObject [
	specialSemantics := anObject
]
