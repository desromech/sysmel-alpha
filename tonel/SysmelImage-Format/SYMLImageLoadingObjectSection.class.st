Class {
	#name : #SYMLImageLoadingObjectSection,
	#superclass : #SAsmBinaryFileComponent,
	#instVars : [
		'objects',
		'size'
	],
	#category : #'SysmelImage-Format'
}

{ #category : #adding }
SYMLImageLoadingObjectSection >> add: anObject [
	objects add: anObject.
	^ anObject
]

{ #category : #writing }
SYMLImageLoadingObjectSection >> fileOffset: newOffset [
	| currentOffset |
	super fileOffset: newOffset.
	currentOffset := newOffset.
	objects do: [ :object |
		object fileOffset: currentOffset.
		currentOffset := currentOffset + (object size alignedTo: 16).
	].

	self assert: (currentOffset - newOffset) = self size
]

{ #category : #initialization }
SYMLImageLoadingObjectSection >> initialize [
	super initialize.
	objects := OrderedCollection new.
	
]

{ #category : #accessing }
SYMLImageLoadingObjectSection >> objects [
	^ objects
]

{ #category : #accessing }
SYMLImageLoadingObjectSection >> prepareForWritingToFile [
	objects do: #prepareForWritingToFile
]

{ #category : #accessing }
SYMLImageLoadingObjectSection >> size [
	size ifNotNil: [ ^ size ].
	size := 0.
	objects do: [ :object |
		size := size + (object size alignedTo: 16).
	].
	
	^ size
]

{ #category : #writing }
SYMLImageLoadingObjectSection >> writeOn: aStream [
	| objectSize padding |
	objects do: [ :object |
		self assert: (object fileOffset = aStream position).
		object writeOn: aStream.
		
		objectSize := object size.
		padding := (objectSize alignedTo: 16) - objectSize.
		padding ~= 0 ifTrue: [ 
			aStream nextPutAll: (ByteArray new: padding)
		]
	]
]
