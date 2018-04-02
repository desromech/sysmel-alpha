Class {
	#name : #SYMLAbstractType,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'usedTraits',
		'symbols'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #adding }
SYMLAbstractType >> addSymbol: aSymbol value: newValue [
	symbols at: aSymbol ifPresent: [ :existent |
		self error: 'Trying to override symbol {1} with {2}.' format: { aSymbol printString . newValue printString }
	] ifAbsentPut: [ newValue ]
]

{ #category : #accessing }
SYMLAbstractType >> addTrait: aTrait [
	usedTraits add: aTrait
]

{ #category : #accessing }
SYMLAbstractType >> addTraits: aCollectionOfTraits [
	aCollectionOfTraits do: [ :trait | self addTrait: aCollectionOfTraits ].
]

{ #category : #definition }
SYMLAbstractType >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> coerceValue: value into: targetType at: coercionPosition [
	(self isSysmelKindOf: targetType) ifTrue: [ ^ value ].
	self halt
]

{ #category : #definition }
SYMLAbstractType >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	
	| traitScope |
	traitScope := self definitionScopeClass parent: aDefinitionBlock environment.
	traitScope programEntity: self.
	
	aDefinitionBlock value analyzeAndEvaluateInEnvironment: traitScope.

]

{ #category : #definition }
SYMLAbstractType >> definitionScopeClass [
	^ SYMLTraitableScope
]

{ #category : #definition }
SYMLAbstractType >> extend: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #initialization }
SYMLAbstractType >> initialize [
	super initialize.
	usedTraits := OrderedCollection new.
	symbols := SYMLOrderedDictionary new.
	
]

{ #category : #testing }
SYMLAbstractType >> isMetaObjectType [
	^ self == self compilationTarget compilerObjectType
]

{ #category : #testing }
SYMLAbstractType >> isSysmelKindOf: anotherType [
	self == anotherType ifTrue: [ ^ true ].
	usedTraits do: [ :used |
		(used isSysmelKindOf: anotherType) ifTrue: [ ^ true ].
	].
	^ false
	
]

{ #category : #testing }
SYMLAbstractType >> isType [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> lookSymbol: symbol ifPresent: ifPresentBlock [
	| resultBlock |
	resultBlock := [ :existent | ^ ifPresentBlock value: existent ].
	symbols at: symbol ifPresent: resultBlock.
	usedTraits do: [ :trait | trait lookSymbol: symbol ifPresent: resultBlock ].
	^ nil
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [message selector numArgs = 0]) ifTrue: [
		self name: message selector.
		^ message receiver
	].

	self lookSymbol: message selector ifPresent: [ :symbol |
		^ symbol analyzeAndEvaluateMessage: message toReceiver: self inEnvironment: environment at: aPosition
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLAbstractType >> usedTraits [
	^ usedTraits
]

{ #category : #accessing }
SYMLAbstractType >> usedTraits: anObject [
	usedTraits := anObject
]

{ #category : #accessing }
SYMLAbstractType >> uses: usedTraitOrTraits [
	<compileTime>
	usedTraitOrTraits isCollection ifTrue: [
		self addTraits: usedTraitOrTraits
	] ifFalse: [
		self addTrait: usedTraitOrTraits
	]
]
