Trait {
	#name : #TMbndMacroMethodContainer,
	#instVars : [
		'macroMethodDict'
	],
	#traits : 'TMbndAbstractMacroMethodContainer',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndMacroMethodContainer >> addInstanceAccessor: accessor for: selector [
	self macroMethodDict at: selector put: accessor.
	self recordMacroMethodAddition: accessor withSelector: selector.
	accessor parent: self
]

{ #category : #adding }
TMbndMacroMethodContainer >> addMacroMethod: macroMethod [
	self macroMethodDict at: macroMethod selector put: macroMethod.
	self recordMacroMethodAddition: macroMethod withSelector: macroMethod selector.
]

{ #category : #accessing }
TMbndMacroMethodContainer >> addStaticAccessor: accessor for: selector [
	self macroMethodDict at: selector put: accessor.
	self recordMacroMethodAddition: accessor withSelector: selector.
	accessor parent: self
]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> lookupLocalMacroSelector: aSelector [
	(macroMethodDict isNil or: [ (macroMethodDict includesKey: aSelector) not ]) ifTrue: [ 
		self evaluateAllPendingDefinitionFragments.
	].

	macroMethodDict ifNil: [ ^ nil ].
	^ self macroMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> lookupMacroSelector: aSelector [
	^ self lookupLocalMacroSelector: aSelector
]

{ #category : #accessing }
TMbndMacroMethodContainer >> macroMethodDict [
	^ macroMethodDict ifNil: [ macroMethodDict := Dictionary new ]
]

{ #category : #accessing }
TMbndMacroMethodContainer >> macroMethodDict: aDictionary [
	macroMethodDict := aDictionary
]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> onMacroSelector: aSelector do: aBlock [
	self macroMethodDict at: aSelector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndBlockClosureMacro new block: aBlock)

]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> onMacroSelectors: aCollectionOfSelectors do: aBlock [
	aCollectionOfSelectors do: [:selector |
		self onMacroSelector: selector do: aBlock
	]
]

{ #category : #'as yet unclassified' }
TMbndMacroMethodContainer >> recordMacroMethodAddition: method withSelector: selector [
	"Hook: for recording macro extension methods"
]
