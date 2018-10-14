Class {
	#name : #SYMLLexicalScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'symbols',
		'metaMethodDictionary',
		'usedNamespaces',
		'cleanUpActions'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLLexicalScope >> addLocalVariable: aLocalVariable at: aPosition [
	symbols at: aLocalVariable name ifPresent: [ :existent |
		self error: 'Local variable {1} overrides an existent symbol in the scope.' format: { aLocalVariable name } at: aPosition
	] ifAbsentPut: [ aLocalVariable ].
	self definitionProgramEntity addLocal: aLocalVariable.
]

{ #category : #adding }
SYMLLexicalScope >> addMetaMethod: selector value: value [
	metaMethodDictionary at: selector ifPresent: [ :existent |
		self error: 'Trying to override meta method {1} with value {2}.' format: { selector printString . value }
	] ifAbsentPut: [ value ]
]

{ #category : #accessing }
SYMLLexicalScope >> cleanUpActions [
	^ cleanUpActions
]

{ #category : #'as yet unclassified' }
SYMLLexicalScope >> generateSSACleanUpActionsWith: aBuilder [
	cleanUpActions do: [ :action |
		action generateSSACodeWith: aBuilder.
		aBuilder isLastTerminator ifTrue: [ ^ self ].
	].

]

{ #category : #initialization }
SYMLLexicalScope >> initialize [
	super initialize.
	symbols := Dictionary new.
	metaMethodDictionary := Dictionary new.
	cleanUpActions := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SYMLLexicalScope >> lookMetaMethodSelector: selector [
	metaMethodDictionary at: selector ifPresent: [ :metaMethod | ^ metaMethod ].
	^ super lookMetaMethodSelector: selector
	
]

{ #category : #'as yet unclassified' }
SYMLLexicalScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbol == #__thisLexicalScope ifTrue: [ ^ ifPresentBlock value: self ].
	^ symbols at: symbol ifPresent: ifPresentBlock
	
]

{ #category : #enumerating }
SYMLLexicalScope >> onCleanupDo: aCleanupActionLazyValue [
	<compileTime>
	<lazy>
	<rewrite>
	
	self assert: aCleanupActionLazyValue environment == self.
	cleanUpActions add: (aCleanupActionLazyValue node semanticAnalysisInEnvironment: self).
	
	"Remove myself from the APSG tree."
	^ nil asAPSGNodeInEnvironment: self at: aCleanupActionLazyValue node position
]

{ #category : #initialization }
SYMLLexicalScope >> setSymbol: symbol value: value [
	symbols at: symbol put: value
]

{ #category : #adding }
SYMLLexicalScope >> symbol: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock

]

{ #category : #'as yet unclassified' }
SYMLLexicalScope >> useNamespace: aNamespace [
	<compileTime>
	self usedNamespaces add: aNamespace.
	^ nil
]

{ #category : #accessing }
SYMLLexicalScope >> usedNamespaces [
	^ usedNamespaces ifNil: [ usedNamespaces := SLVMOrderedInsertionSet new. ]
]

{ #category : #enumerating }
SYMLLexicalScope >> usedNamespacesDo: aBlock [
	usedNamespaces ifNotNil: [ usedNamespaces do: aBlock ]
]
