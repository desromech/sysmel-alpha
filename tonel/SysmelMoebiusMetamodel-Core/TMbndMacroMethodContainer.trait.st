Trait {
	#name : #TMbndMacroMethodContainer,
	#instVars : [
		'macroMethodDict'
	],
	#traits : 'TMbndAbstractMacroMethodContainer',
	#classTraits : 'TMbndAbstractMacroMethodContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndMacroMethodContainer >> addInstanceAccessor: accessor for: selector [
	self macroMethodDict at: selector put: accessor
]

{ #category : #adding }
TMbndMacroMethodContainer >> addMacroMethod: macroMethod [
	self macroMethodDict at: macroMethod selector put: macroMethod
]

{ #category : #accessing }
TMbndMacroMethodContainer >> addStaticAccessor: accessor for: selector [
	self macroMethodDict at: selector put: accessor
]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> lookupLocalMacroSelector: aSelector [
	macroMethodDict ifNil: [ ^ nil ].
	^ self macroMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> lookupMacroSelector: aSelector [
	macroMethodDict ifNil: [ ^ nil ].
	^ self macroMethodDict at: aSelector ifAbsent: [ nil ].
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
