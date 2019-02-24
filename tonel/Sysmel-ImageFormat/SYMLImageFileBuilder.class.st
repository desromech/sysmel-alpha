Class {
	#name : #SYMLImageFileBuilder,
	#superclass : #Object,
	#instVars : [
		'header',
		'sectionDescriptors',
		'sectionContents',
		'loadingObjectSection',
		'internedSymbols',
		'originalSectionToDescriptorDictionary',
		'symbolTable',
		'convertedSymbols'
	],
	#pools : [
		'SYMLImageConstants'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #adding }
SYMLImageFileBuilder >> addBinaryObjectSection: originalSection [
	| descriptor flags debuggingSection |
	descriptor := self sectionDescriptorClass new.
	descriptor
		nameSymbol: (self internSymbol: originalSection name);
		originalSection: originalSection;
		yourself.
		
	flags := 0.
	originalSection readable ifTrue: [ flags := flags | SectionMemoryFlags_Readable ].
	originalSection writeable ifTrue: [ flags := flags | SectionMemoryFlags_Writeable ].
	originalSection executable ifTrue: [ flags := flags | SectionMemoryFlags_Executable ].

	originalSection loaded ifTrue: [flags := flags | SectionMemoryFlags_Loaded ].
	debuggingSection := (originalSection debugging isNotNil and: [originalSection debugging])
		or: [ originalSection name beginsWith: '.debug' ].
	debuggingSection ifTrue: [ flags := flags | SectionMemoryFlags_Debugging ].
	descriptor
		memoryFlags: flags.
	
	originalSectionToDescriptorDictionary at: originalSection put: descriptor.
	
	sectionDescriptors add: descriptor.
	originalSection data ifNotNil: [
		descriptor content: originalSection.
		sectionContents add: originalSection
	]
]

{ #category : #adding }
SYMLImageFileBuilder >> addBinaryObjectSymbol: originalSymbol [
	| symbolEntry |
	symbolEntry := loadingObjectSection add: self symbolTableEntryClass new.
	symbolEntry
		name: (self internSymbol: originalSymbol name);
		symbolSize: originalSymbol size;
		type: (SAsmSymbolTypeMap at: originalSymbol type);
		visibility: (SAsmSymbolVisibilityMap at: originalSymbol visibility).

	convertedSymbols at: originalSymbol put: symbolEntry.
	
	originalSymbol section ifNil: [
		symbolEntry
			sectionOffset: originalSymbol value;
			value: originalSymbol value
	] ifNotNil: [ :originalSection |
		originalSection convertSymbol: originalSymbol intoSysmelImageSymbolEntry: symbolEntry with: self.
	].
	
	symbolTable addEntry: symbolEntry.
	
	originalSymbol name = #__sylsif_entryPoint ifTrue: [ 
		header entryPointObject: symbolEntry.
	]
]

{ #category : #writing }
SYMLImageFileBuilder >> allComponentsDo: aBlock [
	aBlock value: header.
	sectionDescriptors do: aBlock.
	sectionContents do: aBlock.
	aBlock value: loadingObjectSection.
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> arrayClass [
	^ self subclassResponsibility
]

{ #category : #writing }
SYMLImageFileBuilder >> computeFileBinaryElementsOffsets [
	| offset |
	offset := 0.
	self allComponentsDo: [ :component |
		component fileOffset: offset.
		offset := offset + component fileSize
	]
]

{ #category : #adding }
SYMLImageFileBuilder >> convertSectionRelocations: originalSection [
	| descriptor convertedRelocations relocationTable |
	descriptor := originalSectionToDescriptorDictionary at: originalSection.
	
	convertedRelocations := originalSection relocations collect: [ :originalRelocation |
		(loadingObjectSection add: self relocationWithAddendClass new)
			vtable: (SAsmRelocationTypeMap at: originalRelocation type);
			section: (originalSectionToDescriptorDictionary at: originalRelocation section ifAbsent: [nil]);
			symbol: (convertedSymbols at: originalRelocation symbol ifAbsent: [nil]);
			sectionOffset: originalRelocation offset;
			addend: originalRelocation addend;
			yourself.
	].

	relocationTable := (loadingObjectSection add: self arrayClass new)
		value: convertedRelocations;
		yourself.
	
	descriptor relocationTable: relocationTable
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> headerClass [
	self subclassResponsibility
]

{ #category : #initialization }
SYMLImageFileBuilder >> initialize [
	super initialize.
	header := self headerClass new.
	internedSymbols := Dictionary new.

	originalSectionToDescriptorDictionary := IdentityDictionary new.
	convertedSymbols := IdentityDictionary new.
	sectionDescriptors := OrderedCollection new.
	sectionContents := OrderedCollection new.

	loadingObjectSection := SYMLImageLoadingObjectSection new.
	sectionDescriptors add: (self sectionDescriptorClass new
		content: loadingObjectSection;
		memoryFlags: (SectionMemoryFlags_Loaded | SectionMemoryFlags_Readable | SectionMemoryFlags_Writeable | SectionMemoryFlags_ObjectWithFilePointers);
		yourself
	).
	sectionDescriptors first nameSymbol: (self internSymbol: #'.sylsif.objects').
	
	symbolTable := loadingObjectSection add: (self symbolTableClass new
		symbols: (loadingObjectSection add:
			(self arrayClass new value: OrderedCollection new)
			)
		).
	header globalSymbolTable: symbolTable.

]

{ #category : #adding }
SYMLImageFileBuilder >> internSymbol: aSymbol [
	aSymbol ifNil: [ ^ nil ].
	^ internedSymbols at: aSymbol ifAbsentPut: [ 
		loadingObjectSection add: (self symbolClass new value: aSymbol utf8Encoded)
	]
]

{ #category : #writing }
SYMLImageFileBuilder >> prepareForWriting [
	self computeFileBinaryElementsOffsets.
	self allComponentsDo: [:component |
		component prepareForWritingToFile
	].

	header numberOfSections: sectionDescriptors size.

]

{ #category : #'format classes' }
SYMLImageFileBuilder >> relocationWithAddendClass [
	^ self subclassResponsibility
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> sectionDescriptorClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLImageFileBuilder >> sectionDescriptorFor: sasmSymbol [
	^ originalSectionToDescriptorDictionary at: sasmSymbol
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> stringClass [
	self subclassResponsibility
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> symbolClass [
	self subclassResponsibility
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> symbolTableClass [
	^ self subclassResponsibility
]

{ #category : #'format classes' }
SYMLImageFileBuilder >> symbolTableEntryClass [
	^ self subclassResponsibility
]

{ #category : #writing }
SYMLImageFileBuilder >> writeToStream: stream [
	self prepareForWriting.
	self allComponentsDo: [ :el |
		self assert: el fileOffset = stream position.
		el writeOn: stream.
		self assert: el fileOffset + el fileSize = stream position.
	].
]
