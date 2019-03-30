"
I am a language specific top-level scope.
"
Class {
	#name : #MbndLanguageTopLevelScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'topLevelMacros',
		'topLevelSymbols'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelMacros [
	"This is the place for adding top-level macros."
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelSymbols [
	"This is the place for adding top-level symbols"
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> initialize [
	super initialize.
	topLevelMacros := Dictionary new.
	topLevelSymbols := Dictionary new.
	self
		addTopLevelMacros;
		addTopLevelSymbols
]

{ #category : #'macro expansion' }
MbndLanguageTopLevelScope >> lookupMacroSelector: selector [
	topLevelMacros at: selector ifPresent: [ :macro | ^ macro ].
	^ super lookupMacroSelector: selector
]

{ #category : #'macro expansion' }
MbndLanguageTopLevelScope >> lookupSymbol: aSymbol [
	^ topLevelSymbols at: aSymbol ifAbsent: [ nil ]
]

{ #category : #'macro addition' }
MbndLanguageTopLevelScope >> macroSelector: aSelector do: aBlock [
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
