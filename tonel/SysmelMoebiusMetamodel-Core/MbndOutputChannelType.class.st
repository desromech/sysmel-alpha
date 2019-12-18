Class {
	#name : #MbndOutputChannelType,
	#superclass : #MbndIOChannelType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndOutputChannelType class >> typeName [
	^ #_OutputChannelType
]

{ #category : #visiting }
MbndOutputChannelType >> accept: visitor [
	^ visitor visitOutputChannelType: self
]

{ #category : #initialization }
MbndOutputChannelType >> addInstanceMacros [
	self class == MbndOutputChannelType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #send: do: [ :node :builder |
			(builder sendIntoOutputChannel: node receiver message: node arguments first)
				position: node
		]
]

{ #category : #'testing methods' }
MbndOutputChannelType >> isOutputChannelType [
	^ true
]

{ #category : #printing }
MbndOutputChannelType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	messageType printOn: aStream.
	aStream nextPutAll: ' outputChannel'
]
