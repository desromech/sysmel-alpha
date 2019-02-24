Class {
	#name : #SYMLImageSymbolTableEntry,
	#superclass : #SYMLImageObject,
	#instVars : [
		'name',
		'sectionDescriptor',
		'nameFileOffset',
		'sectionDescriptorFileOffset',
		'sectionOffset',
		'symbolSize',
		'value',
		'type',
		'visibility',
		'flags'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #accessing }
SYMLImageSymbolTableEntry >> flags [
	^ flags
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> flags: anObject [
	flags := anObject
]

{ #category : #initialization }
SYMLImageSymbolTableEntry >> initialize [
	super initialize.
	
	nameFileOffset := 0.
	sectionDescriptorFileOffset := 0.
	sectionOffset := 0.
	symbolSize := 0.
	value := 0.
	type := 0.
	visibility := 0.
	flags := 0.
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> name [
	^ name
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> nameFileOffset [
	^ nameFileOffset
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> nameFileOffset: anObject [
	nameFileOffset := anObject
]

{ #category : #writing }
SYMLImageSymbolTableEntry >> nonPointerSize [
	^ 8
]

{ #category : #writing }
SYMLImageSymbolTableEntry >> pointerMemberNames [
	^ #(nameFileOffset sectionDescriptorFileOffset sectionOffset symbolSize value)
]

{ #category : #writing }
SYMLImageSymbolTableEntry >> prepareForWritingToFile [
	nameFileOffset := name ifNil: [ 0 ] ifNotNil: #fileOffset.
	sectionDescriptorFileOffset := sectionDescriptor ifNil: [ 0 ] ifNotNil: #fileOffset.
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionDescriptor [
	^ sectionDescriptor
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionDescriptor: anObject [
	sectionDescriptor := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionDescriptorFileOffset [
	^ sectionDescriptorFileOffset
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionDescriptorFileOffset: anObject [
	sectionDescriptorFileOffset := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionOffset [
	^ sectionOffset
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> sectionOffset: anObject [
	sectionOffset := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> symbolSize [
	^ symbolSize
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> symbolSize: anObject [
	symbolSize := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> type [
	^ type
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> value [
	^ value
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> value: anObject [
	value := anObject
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> visibility [
	^ visibility
]

{ #category : #accessing }
SYMLImageSymbolTableEntry >> visibility: anObject [
	visibility := anObject
]

{ #category : #writing }
SYMLImageSymbolTableEntry >> vtableValue [
	^ VTable_SymbolTableEntry
]

{ #category : #writing }
SYMLImageSymbolTableEntry >> writeNonPointerData: aStream [
	aStream
		nextPutInt8: type;
		nextPutInt8: visibility;
		nextPutInt16: 0;
		nextPutInt32: flags
]
