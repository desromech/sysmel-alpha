Trait {
	#name : #TMbndNamespaceLikeSymbolContainer,
	#traits : 'TMbndMacroMethodContainer + TMbndMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndMacroMethodContainer classTrait + TMbndMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> lookupLocalSymbol: aSymbol [
	^ self methodDict at: aSymbol ifAbsent: [ nil ]
]

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> lookupSymbol: aSymbol [
	^ self lookupSelector: aSymbol
]

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> setLocalSymbol: aSymbol value: aValue [
	^ self methodDict at: aSymbol put: aValue
]
