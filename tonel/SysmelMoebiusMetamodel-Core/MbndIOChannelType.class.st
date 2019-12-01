Class {
	#name : #MbndIOChannelType,
	#superclass : #MbndOpaqueHandleType,
	#instVars : [
		'messageType'
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
