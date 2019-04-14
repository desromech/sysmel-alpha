Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'symbolTable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #adding }
MbndLexicalScope >> addSymbol: symbol binding: binding [
	^ self addSymbol: symbol binding: binding ifPresent: [:existent |
		self error: 'Overriding local binding for {1} with {2}.' format: { symbol asPrettySymbolName . binding }
	]
]

{ #category : #adding }
MbndLexicalScope >> addSymbol: symbol binding: binding ifPresent: aBlock [
	self assert: binding isMbndSymbolBinding.
	^ symbolTable at: symbol ifPresent: aBlock ifAbsentPut: [ binding ]
]

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbolTable := Dictionary new.
]

{ #category : #'macro expansion' }
MbndLexicalScope >> lookupSymbol: aSymbol [
	^ symbolTable at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
MbndLexicalScope >> symbolTable [
	^ symbolTable
]
