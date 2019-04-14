Class {
	#name : #SYMLImageFileBuilder32,
	#superclass : #SYMLImageFileBuilder,
	#category : #'SysmelImage-Format'
}

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> arrayClass [
	^ SYMLImageArray32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> headerClass [
	^ SYMLImageFileHeader32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> relocationWithAddendClass [
	^ SYMLImageRelocationWithAddend32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> sectionDescriptorClass [
	^ SYMLImageSectionDescriptor32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> stringClass [
	^ SYMLImageString32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> symbolClass [
	^ SYMLImageSymbol32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> symbolTableClass [
	^ SYMLImageSymbolTable32
]

{ #category : #'format classes' }
SYMLImageFileBuilder32 >> symbolTableEntryClass [
	^ SYMLImageSymbolTableEntry32
]
