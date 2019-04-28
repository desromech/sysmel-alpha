Trait {
	#name : #TMbndNamespaceLikeSymbolContainer,
	#instVars : [
		'usedNamespaces'
	],
	#traits : 'TMbndMacroMethodContainer + TMbndMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndMacroMethodContainer classTrait + TMbndMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> lookupLocalSymbol: aSymbol [
	overloadedMethodDict ifNil: [ ^ nil ].
	^ self overloadedMethodDict at: aSymbol ifAbsent: [ nil ]
]

{ #category : #methods }
TMbndNamespaceLikeSymbolContainer >> lookupOverloadedSelector: aSelector [
	(self lookupLocalOverloadedSelector: aSelector) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupOverloadedSelector: aSelector) ifNotNil: [ :found | ^ found ].
	].
	
	^ nil
]

{ #category : #methods }
TMbndNamespaceLikeSymbolContainer >> lookupSelector: aSelector [
	(self lookupLocalSelector: aSelector) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupSelector: aSelector) ifNotNil: [ :found | ^ found ].
	].
	
	^ nil
]

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> lookupSymbol: aSymbol [
	(self lookupLocalSymbol: aSymbol) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupSymbol: aSymbol) ifNotNil: [ :found | ^ found ].
	].

	^ nil
]

{ #category : #'member symbols' }
TMbndNamespaceLikeSymbolContainer >> setLocalSymbol: aSymbol value: aValue [
	self overloadedMethodDict at: aSymbol put: aValue.
	self methodDict at: aSymbol put: aValue
]

{ #category : #'as yet unclassified' }
TMbndNamespaceLikeSymbolContainer >> useAndExportNamespace: usedNamespace [
	self assert: usedNamespace isNamespace.
	self usedNamespaces add: usedNamespace
]

{ #category : #'as yet unclassified' }
TMbndNamespaceLikeSymbolContainer >> usedNamespaces [
	^ usedNamespaces ifNil: [ usedNamespaces := SLVMOrderedInsertionSet new ]
]
