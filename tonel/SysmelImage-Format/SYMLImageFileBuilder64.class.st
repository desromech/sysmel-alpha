Class {
	#name : #SYMLImageFileBuilder64,
	#superclass : #SYMLImageFileBuilder,
	#category : #'SysmelImage-Format'
}

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> arrayClass [
	^ SYMLImageArray64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> headerClass [
	^ SYMLImageFileHeader64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> relocationWithAddendClass [
	^ SYMLImageRelocationWithAddend64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> sectionDescriptorClass [
	^ SYMLImageSectionDescriptor64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> stringClass [
	^ SYMLImageString64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> symbolClass [
	^ SYMLImageSymbol64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> symbolTableClass [
	^ SYMLImageSymbolTable64
]

{ #category : #'format classes' }
SYMLImageFileBuilder64 >> symbolTableEntryClass [
	^ SYMLImageSymbolTableEntry64
]
