Class {
	#name : #SYMLImageLoadingObjectSection,
	#superclass : #SAsmBinaryFileComponent,
	#instVars : [
		'objects',
		'size'
	],
	#category : #'Sysmel-ImageFormat'
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
		currentOffset := currentOffset + object size.
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
		size := size + object size
	].
	
	^ size
]

{ #category : #writing }
SYMLImageLoadingObjectSection >> writeOn: aStream [
	objects do: [ :object |
		object writeOn: aStream
	]
]
