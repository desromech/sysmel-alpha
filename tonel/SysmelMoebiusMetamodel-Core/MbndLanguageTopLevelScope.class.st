"
I am a language specific top-level scope.
"
Class {
	#name : #MbndLanguageTopLevelScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'languageName',
		'topLevelMacros',
		'topLevelSymbols',
		'module',
		'compilationTarget',
		'usedNamespaces'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #'instance creation' }
MbndLanguageTopLevelScope class >> for: aModule [
	^ self new initializeWithModule: aModule
]

{ #category : #serialization }
MbndLanguageTopLevelScope class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	objectType == #LanguageTopLevelScope ifTrue: [
		| result |
		self assert: earlyFields isSymbol.
		result := graphDecoder targetModule newSourceEvaluationScopeForLanguageNamed: earlyFields.
		graphDecoder registerObjectInstance: result.
		graphDecoder decodeNext. "Ignore the normal fields"
		^ result
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelMacros [
	"This is the place for adding top-level macros."
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelSymbols [
	"This is the place for adding top-level symbols"
]

{ #category : #adding }
MbndLanguageTopLevelScope >> addUsedNamespace: namespace [
	self usedNamespaces add: namespace
]

{ #category : #serialization }
MbndLanguageTopLevelScope >> encodeGraphForMessagePackWith: graphEncoder [
	self assert: languageName isNotNil.
	^ graphEncoder encodeObject: self type: self messagePackTypeName earlyFields: languageName fields: [nil]
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> initializeWithModule: aModule [
	module := aModule.
	compilationTarget := module compilationTarget.
	topLevelMacros := Dictionary new.
	topLevelSymbols := Dictionary new.
	self
		addTopLevelMacros;
		addTopLevelSymbols
]

{ #category : #accessing }
MbndLanguageTopLevelScope >> languageName [
	^ languageName
]

{ #category : #accessing }
MbndLanguageTopLevelScope >> languageName: anObject [
	languageName := anObject
]

{ #category : #'macro expansion' }
MbndLanguageTopLevelScope >> lookupMacroSelector: selector [
	topLevelMacros at: selector ifPresent: [ :macro | ^ macro ].
	usedNamespaces ifNotNil: [
		usedNamespaces do: [ :namespace |
			(namespace lookupMacroSelector: selector) ifNotNil: [ :macro |^ macro ]
		].
	].
	^ super lookupMacroSelector: selector
]

{ #category : #'macro expansion' }
MbndLanguageTopLevelScope >> lookupSymbol: aSymbol [
	(topLevelSymbols at: aSymbol ifAbsent: [ nil ]) ifNotNil: [ :found | ^ found ].
	usedNamespaces ifNotNil: [
		usedNamespaces do: [ :namespace |
			(namespace lookupSymbol: aSymbol) ifNotNil: [ :found | ^ found ]
		].
	].

	^ super lookupSymbol: aSymbol
]

{ #category : #serialization }
MbndLanguageTopLevelScope >> messagePackTypeName [
	languageName ifNotNil: [ ^ MbndLanguageTopLevelScope messagePackTypeName ].
	^ super messagePackTypeName
]

{ #category : #'macro addition' }
MbndLanguageTopLevelScope >> onMacroSelector: aSelector do: aBlock [
	topLevelMacros at: aSelector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndBlockClosureMacro new block: aBlock)
		
]

{ #category : #accessing }
MbndLanguageTopLevelScope >> topLevelMacros [
	^ topLevelMacros
]

{ #category : #accessing }
MbndLanguageTopLevelScope >> topLevelSymbols [
	^ topLevelSymbols
]

{ #category : #accessing }
MbndLanguageTopLevelScope >> usedNamespaces [
	^ usedNamespaces ifNil: [ usedNamespaces := OrderedCollection new ]
]
