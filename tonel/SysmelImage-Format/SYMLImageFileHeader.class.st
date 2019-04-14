Class {
	#name : #SYMLImageFileHeader,
	#superclass : #SAsmBinaryFileComponent,
	#instVars : [
		'littleEndian',
		'platform',
		'version',
		'numberOfSections',
		'globalSymbolTable',
		'entryPointObject'
	],
	#pools : [
		'SYMLImageConstants'
	],
	#category : #'SysmelImage-Format'
}

{ #category : #accessing }
SYMLImageFileHeader >> entryPointObject [
	^ entryPointObject
]

{ #category : #accessing }
SYMLImageFileHeader >> entryPointObject: anObject [
	entryPointObject := anObject
]

{ #category : #accessing }
SYMLImageFileHeader >> globalSymbolTable [
	^ globalSymbolTable
]

{ #category : #accessing }
SYMLImageFileHeader >> globalSymbolTable: anObject [
	globalSymbolTable := anObject
]

{ #category : #initialization }
SYMLImageFileHeader >> initialize [
	super initialize.
	littleEndian := true.
	platform := 'none' asByteArray.
	version := '0000' asByteArray.
	numberOfSections := 0.
	
	
]

{ #category : #accessing }
SYMLImageFileHeader >> littleEndian [
	^ littleEndian
]

{ #category : #accessing }
SYMLImageFileHeader >> littleEndian: anObject [
	littleEndian := anObject
]

{ #category : #accessing }
SYMLImageFileHeader >> numberOfSections [
	^ numberOfSections
]

{ #category : #accessing }
SYMLImageFileHeader >> numberOfSections: anObject [
	numberOfSections := anObject
]

{ #category : #accessing }
SYMLImageFileHeader >> platform [
	^ platform
]

{ #category : #accessing }
SYMLImageFileHeader >> platform: anObject [
	platform := anObject
]

{ #category : #accessing }
SYMLImageFileHeader >> pointerSize [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLImageFileHeader >> size [
	^ "signature" 16 
	+ "globalSymbolTable" 8
	+ "entryPointObject" 8
	+ "numberOfSections" 4
	+ "reserved" 4
]

{ #category : #accessing }
SYMLImageFileHeader >> version [
	^ version
]

{ #category : #accessing }
SYMLImageFileHeader >> version: anObject [
	version := anObject
]

{ #category : #writing }
SYMLImageFileHeader >> writeOn: aStream [
	aStream
		nextPutAll: "'SYIF' asByteArray" #[83 89 73 70];
		nextPutAll: (self pointerSize = 4
			ifTrue: [ "'32' asByteArray" #[51 50] ]
			ifFalse: [ "'64' asByteArray" #[54 52] ]);
		nextPutAll: (littleEndian
			ifTrue: ["'LE' asByteArray" #[76 69] ]
			ifFalse: ["'BE' asByteArray" #[66 69] ]);
		nextPutAll: platform;
		nextPutAll: version;
		nextPutInt64: (globalSymbolTable ifNil: [ 0 ] ifNotNil: #fileOffset);
		nextPutInt64: (entryPointObject ifNil: [ 0 ] ifNotNil: #fileOffset);
		nextPutInt32: numberOfSections;
		nextPutInt32: "reserved" 0
]
