"
I am a type that implements the following common functionality:
- Access to the definition module.
- Macro method dictionary.
- Macro method lookup.

"
Trait {
	#name : #TMbndType,
	#instVars : [
		'definitionModule',
		'macroMethodDict',
		'subtypes'
	],
	#traits : 'TMbndAbstractType',
	#classTraits : 'TMbndAbstractType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
TMbndType >> definitionModule: aModule [
	definitionModule := aModule
]

{ #category : #'macro expansion' }
TMbndType >> lookupMacroSelector: aSelector [
	| macro |
	macro := self macroMethodDict at: aSelector ifAbsent: [ nil ]..
	macro ifNotNil: [ ^ macro ].
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #accessing }
TMbndType >> macroMethodDict [
	^ macroMethodDict ifNil: [ macroMethodDict := Dictionary new ]
]

{ #category : #accessing }
TMbndType >> macroMethodDict: aDictionary [
	macroMethodDict := aDictionary
]

{ #category : #accessing }
TMbndType >> module [
	^ definitionModule
]

{ #category : #'macro expansion' }
TMbndType >> onMacroSelector: aSelector do: aBlock [
	self macroMethodDict at: aSelector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndBlockClosureMacro new block: aBlock)

]

{ #category : #'type hierarchy' }
TMbndType >> subtypeAdded: aSubtype [
	^ subtypes := (self subtypes copyWithout: aSubtype) copyWith: aSubtype
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeRemoved: aSubtype [
	^ subtypes := self subtypes copyWithout: aSubtype
]

{ #category : #accessing }
TMbndType >> subtypes [
	^ subtypes ifNil: [ subtypes := #() ]
]
