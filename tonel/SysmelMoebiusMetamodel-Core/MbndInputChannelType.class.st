Class {
	#name : #MbndInputChannelType,
	#superclass : #MbndIOChannelType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndInputChannelType class >> typeName [
	^ #_InputChannelType
]

{ #category : #visiting }
MbndInputChannelType >> accept: visitor [
	^ visitor visitInputChannelType: self
]

{ #category : #initialization }
MbndInputChannelType >> addInstanceMacros [
	self class == MbndInputChannelType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #receive do: [ :node :builder |
			(builder receiveFromInputChannel: node receiver)
				position: node
		]
]

{ #category : #'testing methods' }
MbndInputChannelType >> isInputChannelType [
	^ true
]

{ #category : #printing }
MbndInputChannelType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	
	messageType printOn: aStream.
	aStream nextPutAll: ' inputChannel'
]
