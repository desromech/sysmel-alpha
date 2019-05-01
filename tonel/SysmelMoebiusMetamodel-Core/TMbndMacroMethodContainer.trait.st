Trait {
	#name : #TMbndMacroMethodContainer,
	#instVars : [
		'macroMethodDict'
	],
	#traits : 'TMbndAbstractMacroMethodContainer',
	#classTraits : 'TMbndAbstractMacroMethodContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'macro expansion' }
TMbndMacroMethodContainer >> lookupMacroSelector: aSelector [
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
