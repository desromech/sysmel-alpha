Trait {
	#name : #TMbndSymbolContainer,
	#instVars : [
		'localSymbolTable'
	],
	#traits : 'TMbndAbstractSymbolContainer',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndSymbolContainer >> localSymbolTable [
	^ localSymbolTable ifNil: [ localSymbolTable := Dictionary new. ]
]

{ #category : #'as yet unclassified' }
TMbndSymbolContainer >> localSymbolTableContent [
	| result |
	result := MbndSystemDictionaryContent for: self localSymbolTable size.
	
	localSymbolTable keysAndValuesDo: [ :key :value |
		(value isMbndType or: [ value isNamespace ]) ifTrue: [ 
			result withHash: (self compilationTarget identityHashForSymbolInDictionary: key)
				putKey: key value: value globalBindingAssociation
		].
	].

	^ result
]

{ #category : #'as yet unclassified' }
TMbndSymbolContainer >> localSymbolTableInstanceObject [
	^ self localSymbolTableContent makeInstanceForCompilationTarget: self compilationTarget
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> lookupLocalSymbol: aSymbol [
	(localSymbolTable isNil or: [ (localSymbolTable includesKey: aSymbol) not ]) ifTrue: [ 
		self evaluateAllPendingDefinitionFragments.
	].
	localSymbolTable ifNil: [ ^ nil ].
	^ localSymbolTable at: aSymbol ifAbsent: [ nil ]
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> lookupSymbol: aSymbol [
	^ self lookupLocalSymbol: aSymbol
]

{ #category : #'member symbols' }
TMbndSymbolContainer >> setLocalSymbol: aSymbol value: aValue [
	| result |
	result := self localSymbolTable at: aSymbol put: aValue.
	aValue hasPublicVisibility ifTrue: [
		aValue createPublicAccessorsIn: self
	].
	^ result
]
