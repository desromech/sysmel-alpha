Trait {
	#name : #TMbndSymbolContainer,
	#instVars : [
		'localSymbolTable'
	],
	#traits : 'TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndSymbolContainer >> localSymbolTable [
	^ localSymbolTable ifNil: [ localSymbolTable := Dictionary new. ]
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> lookupLocalSymbol: aSymbol [
	localSymbolTable ifNil: [ ^ nil ].
	^ localSymbolTable at: aSymbol ifAbsent: [ nil ]
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> lookupSymbol: aSymbol [
	^ self lookupLocalSymbol: aSymbol
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> setLocalSymbol: aSymbol value: aValue [
	^ self localSymbolTable at: aSymbol put: aValue
]
