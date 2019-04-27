Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'symbolTable',
		'bindingStorageTable'
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

{ #category : #storage }
MbndLexicalScope >> bindingStorageTable [
	^ bindingStorageTable ifNil: [ bindingStorageTable := Dictionary new ]
]

{ #category : #storage }
MbndLexicalScope >> clearBindingStorage [
	bindingStorageTable ifNotNil: #removeAll
]

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbolTable := Dictionary new.
]

{ #category : #storage }
MbndLexicalScope >> lookBindingStorage: binding [
	bindingStorageTable ifNotNil: [ 
		bindingStorageTable at: binding ifPresent: [ :existent |
			^ existent
		]
	].

	^ nil
]

{ #category : #storage }
MbndLexicalScope >> lookBindingStorageRecursively: binding [
	(self lookBindingStorage: binding) ifNotNil: [ :storage |
		^ storage
	].

	^ parent ifNotNil: [ parent lookBindingStorageRecursively: binding ]
]

{ #category : #'macro expansion' }
MbndLexicalScope >> lookupSymbol: aSymbol [
	^ symbolTable at: aSymbol ifAbsent: [ nil ]
]

{ #category : #storage }
MbndLexicalScope >> setBinding: binding storage: storage [
	^ self bindingStorageTable at: binding put: storage
]

{ #category : #accessing }
MbndLexicalScope >> symbolTable [
	^ symbolTable
]