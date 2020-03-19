Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'symbolTable',
		'bindingStorageTable',
		'usedNamespaces',
		'definitionPosition'
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

{ #category : #accessing }
MbndLexicalScope >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
MbndLexicalScope >> definitionPosition: anObject [
	definitionPosition := anObject
]

{ #category : #serialization }
MbndLexicalScope >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#symbolTable . graphEncoder encodeCompleteSymbolTable: symbolTable .
		#usedNamespaces . usedNamespaces encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbolTable := Dictionary new.
]

{ #category : #testing }
MbndLexicalScope >> isLexicalScope [
	^ true
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

{ #category : #initialization }
MbndLexicalScope >> lookupSymbolOnUsedSymbols: symbol [
	usedNamespaces ifNotNil: [ 
		usedNamespaces do: [ :namespace |
			(namespace lookupSymbol: symbol) ifNotNil: [ :binding | ^ binding ]
		]
	].
	^ nil
]

{ #category : #serialization }
MbndLexicalScope >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	symbolTable := Dictionary newFromPairs: (encodedFields at: #symbolTable).
	usedNamespaces := encodedFields at: #usedNamespaces.
]

{ #category : #storage }
MbndLexicalScope >> setBinding: binding storage: storage [
	^ self bindingStorageTable at: binding put: storage
]

{ #category : #accessing }
MbndLexicalScope >> symbolTable [
	^ symbolTable
]

{ #category : #initialization }
MbndLexicalScope >> useNamespace: aNamespace [
	(usedNamespaces ifNil: [ usedNamespaces := OrderedCollection new])
		add: aNamespace
]
