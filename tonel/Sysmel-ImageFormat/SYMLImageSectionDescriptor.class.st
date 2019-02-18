Class {
	#name : #SYMLImageSectionDescriptor,
	#superclass : #SYMLImageObject,
	#instVars : [
		'nameSymbol',
		'relocationTable',
		'relocationTableFileOffset',
		'sectionFileOffset',
		'sectionFileSize',
		'sectionFileBaseAddress',
		'memoryLoadingAddress',
		'memorySize',
		'memoryAlignment',
		'memoryFlags',
		'content',
		'nameSymbolOffset',
		'originalSection'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #accessing }
SYMLImageSectionDescriptor >> content [
	^ content
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> content: anObject [
	content := anObject
]

{ #category : #initialization }
SYMLImageSectionDescriptor >> initialize [
	super initialize.
	nameSymbol := nil.
	nameSymbolOffset := 0.
	relocationTable := nil.
	relocationTableFileOffset := 0.
	sectionFileOffset := 0.
	sectionFileSize := 0.
	sectionFileBaseAddress := 0.
	memoryLoadingAddress := 0.
	memorySize := 0.
	memoryAlignment := 1.
	memoryFlags := 0.
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryAlignment [
	^ memoryAlignment
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryAlignment: anObject [
	memoryAlignment := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryFlags [
	^ memoryFlags
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryFlags: anObject [
	memoryFlags := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryLoadingAddress [
	^ memoryLoadingAddress
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memoryLoadingAddress: anObject [
	memoryLoadingAddress := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memorySize [
	^ memorySize
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> memorySize: anObject [
	memorySize := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> nameSymbol [
	^ nameSymbol
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> nameSymbol: anObject [
	nameSymbol := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> nameSymbolOffset [
	^ nameSymbolOffset
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> nameSymbolOffset: anObject [
	nameSymbolOffset := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> originalSection [
	^ originalSection
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> originalSection: anObject [
	originalSection := anObject
]

{ #category : #writing }
SYMLImageSectionDescriptor >> pointerMemberNames [
	^ #(nameSymbolOffset relocationTableFileOffset sectionFileOffset sectionFileSize sectionFileBaseAddress memoryLoadingAddress memorySize memoryAlignment memoryFlags)
]

{ #category : #writing }
SYMLImageSectionDescriptor >> prepareForWritingToFile [

	nameSymbol ifNotNil: [ 
		nameSymbolOffset := nameSymbol fileOffset.
	].
	relocationTable ifNotNil: [ 
		relocationTableFileOffset := relocationTable fileOffset.
	].

	content ifNil: [ ^ self ].
	
	sectionFileOffset := content fileOffset.
	sectionFileSize := content size.

]

{ #category : #accessing }
SYMLImageSectionDescriptor >> relocationTable [
	^ relocationTable
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> relocationTable: anObject [
	relocationTable := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> relocationTableFileOffset [
	^ relocationTableFileOffset
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileBaseAddress [
	^ sectionFileBaseAddress
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileBaseAddress: anObject [
	sectionFileBaseAddress := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileOffset [
	^ sectionFileOffset
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileOffset: anObject [
	sectionFileOffset := anObject
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileSize [
	^ sectionFileSize
]

{ #category : #accessing }
SYMLImageSectionDescriptor >> sectionFileSize: anObject [
	sectionFileSize := anObject
]

{ #category : #writing }
SYMLImageSectionDescriptor >> vtableValue [
	^ VTable_SectionDescriptor
]
