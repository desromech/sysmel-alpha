Trait {
	#name : #TMbndNamespaceLikeSymbolContainer,
	#instVars : [
		'usedNamespaces'
	],
	#traits : 'TMbndMacroMethodContainer + TMbndMethodContainer + TMbndSymbolContainer',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
TMbndNamespaceLikeSymbolContainer >> adaptImportedSymbolBinding: aSymbol [
	^ aSymbol
]

{ #category : #enumerating }
TMbndNamespaceLikeSymbolContainer >> importedNamespacesDo: aBlock [
	"By default do nothing. This delegates the lookup into the namespaces with the same name that are defined in imported modules."
]

{ #category : #methods }
TMbndNamespaceLikeSymbolContainer >> lookupMacroSelector: aSelector [
	(self lookupLocalMacroSelector: aSelector) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupMacroSelector: aSelector) ifNotNil: [ :found | ^ found ].
	].
	self importedNamespacesDo: [ :namespace |
		(namespace lookupMacroSelector: aSelector) ifNotNil: [ :found | ^ self adaptImportedSymbolBinding: found ].
	].
	
	^ nil
]

{ #category : #methods }
TMbndNamespaceLikeSymbolContainer >> lookupOverloadedSelector: aSelector [
	self evaluateAllPendingDefinitionFragments.
	(self lookupLocalOverloadedSelector: aSelector) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupOverloadedSelector: aSelector) ifNotNil: [ :found | ^ found ].
	].
	self importedNamespacesDo: [ :namespace |
		(namespace lookupOverloadedSelector: aSelector) ifNotNil: [ :found | ^ self adaptImportedSymbolBinding: found ].
	].
	
	^ nil
]

{ #category : #methods }
TMbndNamespaceLikeSymbolContainer >> lookupSelector: aSelector [
	(self lookupLocalSelector: aSelector) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupSelector: aSelector) ifNotNil: [ :found | ^ found ].
	].
	self importedNamespacesDo: [ :namespace |
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
	self importedNamespacesDo: [ :namespace |
		(namespace lookupSymbol: aSymbol) ifNotNil: [ :found | ^ self adaptImportedSymbolBinding: found ].
	].

	^ nil
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
