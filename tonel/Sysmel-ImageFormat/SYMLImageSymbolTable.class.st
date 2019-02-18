Class {
	#name : #SYMLImageSymbolTable,
	#superclass : #SYMLImageObject,
	#instVars : [
		'symbols',
		'symbolsFileOffset'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #writing }
SYMLImageSymbolTable >> addEntry: aSymbolEntry [
	symbols value add: aSymbolEntry
]

{ #category : #writing }
SYMLImageSymbolTable >> pointerMemberNames [
	^ #(symbolsFileOffset)
]

{ #category : #writing }
SYMLImageSymbolTable >> prepareForWritingToFile [
	symbolsFileOffset := symbols fileOffset
]

{ #category : #accessing }
SYMLImageSymbolTable >> symbols [
	^ symbols
]

{ #category : #accessing }
SYMLImageSymbolTable >> symbols: anObject [
	symbols := anObject
]

{ #category : #accessing }
SYMLImageSymbolTable >> symbolsFileOffset [
	^ symbolsFileOffset
]

{ #category : #accessing }
SYMLImageSymbolTable >> symbolsFileOffset: anObject [
	symbolsFileOffset := anObject
]

{ #category : #writing }
SYMLImageSymbolTable >> vtableValue [
	^ VTable_SymbolTable
]
