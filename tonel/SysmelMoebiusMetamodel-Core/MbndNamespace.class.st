Class {
	#name : #MbndNamespace,
	#superclass : #MbndAbstractNamespace,
	#traits : 'TMbndNamespaceLikeSymbolContainer',
	#classTraits : 'TMbndNamespaceLikeSymbolContainer classTrait',
	#instVars : [
		'parent',
		'children',
		'name',
		'module',
		'importedNamespaces'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #serialization }
MbndNamespace class >> messagePackTypeName [
	^ #Namespace
]

{ #category : #'as yet unclassified' }
MbndNamespace >> adaptImportedSymbolBinding: importedSymbolBinding [
	importedSymbolBinding isNamespace ifTrue: [
		^ self ensureSymbolIsNamespace: importedSymbolBinding name
	].

	^ importedSymbolBinding
]

{ #category : #accessing }
MbndNamespace >> addChild: aChild [
	self assert: aChild parent isNil.
	aChild parent: self.
	self children add: aChild.
]

{ #category : #'semantic analysis' }
MbndNamespace >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode
]

{ #category : #'semantic analysis' }
MbndNamespace >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: self type;
		yourself
]

{ #category : #accessing }
MbndNamespace >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #accessing }
MbndNamespace >> compilationEnvironment [
	^ module compilationEnvironment
]

{ #category : #serialization }
MbndNamespace >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name.
		#macroMethodDict . graphEncoder encodeSymbolTable: macroMethodDict.
		#localSymbolTable . graphEncoder encodeSymbolTable: localSymbolTable.
		#children.  graphEncoder encodeProgramEntityList: children
	}
]

{ #category : #testing }
MbndNamespace >> hasProgramEntityReflectiveNode [
	^ true
]

{ #category : #enumerating }
MbndNamespace >> importedNamespaces [
	(importedNamespaces isNotNil and: [ importedNamespaces size = self module importedModules size ]) ifTrue: [
		^ importedNamespaces
	].

	parent ifNil: [
		self assert: name == #__global.
		^ importedNamespaces := module importedModules collect: [ :each | each globalNamespace ].
	].

	name isMbndAnonymousSymbol ifTrue: [
		^ importedNamespaces := #()
	].

	self assert: parent isNamespace.
	importedNamespaces := parent importedNamespaces collect: [ :parentImportedNamespace |
		parentImportedNamespace localSymbolTable at: name ifAbsent: [ nil ]
	] thenSelect: [ :each | each isNotNil and: [ each isNamespace ] ].
	^ importedNamespaces

]

{ #category : #enumerating }
MbndNamespace >> importedNamespacesDo: aBlock [
	^ self importedNamespaces do: aBlock
]

{ #category : #'member symbols' }
MbndNamespace >> lookupSymbol: aSymbol [
	(self lookupLocalSymbol: aSymbol) ifNotNil: [ :found | ^ found ].
	self usedNamespaces do: [ :namespace |
		(namespace lookupSymbol: aSymbol) ifNotNil: [ :found | ^ found ].
	].
	self importedNamespacesDo: [ :namespace |
		(namespace lookupSymbol: aSymbol) ifNotNil: [ :found | ^ self adaptImportedSymbolBinding: found ].
	].

	^ nil
]

{ #category : #serialization }
MbndNamespace >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name ifAbsent: [nil].
	macroMethodDict := Dictionary newFromPairs: (encodedFields at: #macroMethodDict).
	localSymbolTable := Dictionary newFromPairs: (encodedFields at: #localSymbolTable).
	children := (encodedFields at: #children ifAbsent: [#()]) asOrderedCollection.
]

{ #category : #accessing }
MbndNamespace >> module [
	^ module
]

{ #category : #accessing }
MbndNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndNamespace >> name [
	^ name
]

{ #category : #accessing }
MbndNamespace >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndNamespace >> parent [
	^ parent
]

{ #category : #accessing }
MbndNamespace >> parent: anObject [
	parent := anObject
]

{ #category : #printing }
MbndNamespace >> printOn: aStream [
	aStream nextPutAll: 'namespace '; nextPutAll: self qualifiedName asPrettySymbolName
]

{ #category : #printing }
MbndNamespace >> qualifiedNameForParent [
	parent ifNil: [ ^ '' ].
	^ super qualifiedNameForParent
]

{ #category : #'semantic analysis' }
MbndNamespace >> type [
	^ self compilationTarget namespaceType
]
