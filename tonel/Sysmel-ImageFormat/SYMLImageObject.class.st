Class {
	#name : #SYMLImageObject,
	#superclass : #SAsmBinaryFileComponent,
	#pools : [
		'SYMLImageConstants'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #writing }
SYMLImageObject >> nonPointerSize [
	^ 0
]

{ #category : #'as yet unclassified' }
SYMLImageObject >> objectHeaderSize [
	^ 16
]

{ #category : #writing }
SYMLImageObject >> pointerMemberNames [
	self subclassResponsibility
]

{ #category : #writing }
SYMLImageObject >> pointerSize [
	self subclassResponsibility
]

{ #category : #writing }
SYMLImageObject >> size [
	^ self objectHeaderSize +
	(self pointerMemberNames size * self pointerSize) +
	self nonPointerSize +
	self variableDataByteSize
]

{ #category : #writing }
SYMLImageObject >> variableDataByteSize [
	^ 0
]

{ #category : #writing }
SYMLImageObject >> variableDataSize [
	^ 0
]

{ #category : #writing }
SYMLImageObject >> vtableValue [
	^ self subclassResponsibility
]

{ #category : #writing }
SYMLImageObject >> writeNonPointerData: aStream [
]

{ #category : #writing }
SYMLImageObject >> writeObjectHeaderOn: aStream [
	aStream
		nextPutInt64: self vtableValue;
		nextPutInt32: 0;
		nextPutInt32: self variableDataSize
]

{ #category : #writing }
SYMLImageObject >> writeOn: aStream [
	self writeObjectHeaderOn: aStream.
	
	"Write the pointer members"
	self pointerSize = 4 ifTrue: [
		self pointerMemberNames do: [ :member | aStream nextPutInt32: (self perform: member) ].
	] ifFalse: [ 
		self pointerMemberNames do: [ :member | aStream nextPutInt64: (self perform: member) ].
	].

	self writeNonPointerData: aStream.

	self writeVariableDataOn: aStream
]

{ #category : #writing }
SYMLImageObject >> writeVariableDataOn: aStream [
	
]
