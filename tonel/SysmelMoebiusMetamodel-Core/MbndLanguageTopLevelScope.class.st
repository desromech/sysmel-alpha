"
I am a language specific top-level scope.
"
Class {
	#name : #MbndLanguageTopLevelScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'topLevelMacros',
		'topLevelSymbols',
		'module',
		'compilationTarget'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #'instance creation' }
MbndLanguageTopLevelScope class >> for: aModule [
	^ self new initializeWithModule: aModule
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelMacros [
	"This is the place for adding top-level macros."
]

{ #category : #initialization }
MbndLanguageTopLevelScope >> addTopLevelSymbols [
	"This is the place for adding top-level symbols"
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
