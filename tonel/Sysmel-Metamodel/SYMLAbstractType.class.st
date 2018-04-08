Class {
	#name : #SYMLAbstractType,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'usedTraits',
		'symbols',
		'methodDictionary',
		'metaType',
		'flattenedTraits',
		'traitUsers'
	],
	#classVars : [
		'SpecialMetaSymbols'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #initialization }
SYMLAbstractType class >> initialize [
	super initialize.
	SpecialMetaSymbols := Dictionary newFromPairs: { 
		#meta . [ :programEntity :module | programEntity type ].
		#method . [ :programEntity :module | SYMLMetaBuilder for: SYMLMethod module: module parent: programEntity ].
		#message . [ :programEntity :module | SYMLMetaBuilder for: SYMLMessageMethod module: module parent: programEntity ]
	}.
]

{ #category : #initialization }
SYMLAbstractType class >> specialMetaSymbols [
	^ SpecialMetaSymbols
]

{ #category : #adding }
SYMLAbstractType >> addSymbol: aSymbol value: newValue [
	newValue isAbstractFunction ifTrue: [
		methodDictionary at: aSymbol ifPresent: [ :existent |
			self error: 'Trying to override selector {1} with {2}.' format: { aSymbol printString . newValue printString }
		] ifAbsentPut: [ newValue ].
		newValue addedToAbstractType: self.
		^ self.
	].

	symbols at: aSymbol ifPresent: [ :existent |
		self error: 'Trying to override symbol {1} with {2}.' format: { aSymbol printString . newValue printString }
	] ifAbsentPut: [ newValue ]
]

{ #category : #accessing }
SYMLAbstractType >> addTrait: aTrait [
	(aTrait isSysmelKindOf: self) ifTrue: [
		self error: 'Adding circular trait.'
	].

	usedTraits add: aTrait.
	aTrait addTraitUser: self.
	self isMetaType ifFalse: [ 
		self type addTrait: aTrait type
	].

	self invalidateFlattenedTraits.
]

{ #category : #accessing }
SYMLAbstractType >> addTraitUser: aTraitUser [
	traitUsers add: aTraitUser

]

{ #category : #accessing }
SYMLAbstractType >> addTraits: aCollectionOfTraits [
	aCollectionOfTraits do: [ :trait | self addTrait: trait ].
]

{ #category : #definition }
SYMLAbstractType >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #testing }
SYMLAbstractType >> canBeCoercedImplicitlyInto: targetType [
	self == targetType ifTrue: [ ^ true ].
	usedTraits do: [ :trait |
		(trait canBeCoercedImplicitlyInto: targetType) ifTrue: [ ^ true ]
	].

	^ false
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
	^ SYMLAbstractTypeScope
]

{ #category : #definition }
SYMLAbstractType >> extend: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #accessing }
SYMLAbstractType >> flattenTraitsInto: target visited: visited [
	(visited includes: self) ifTrue: [ ^ self ].
	visited add: self.
	
	usedTraits do: [ :trait | trait flattenTraitsInto: target visited: visited ].
	target add: self.
	
]

{ #category : #accessing }
SYMLAbstractType >> flattenedTraits [
	flattenedTraits ifNotNil: [ ^ flattenedTraits ].
	flattenedTraits := OrderedCollection new.
	self flattenTraitsInto: flattenedTraits visited: IdentitySet new.
	flattenedTraits := flattenedTraits asArray.
	^ flattenedTraits
]

{ #category : #initialization }
SYMLAbstractType >> initialize [
	super initialize.
	usedTraits := OrderedCollection new.
	traitUsers := WeakSet new.
	symbols := SYMLOrderedDictionary new.
	methodDictionary := SYMLOrderedDictionary new.
]

{ #category : #accessing }
SYMLAbstractType >> invalidateFlattenedTraits [
	flattenedTraits := nil.
	traitUsers do: #invalidateFlattenedTraits
]

{ #category : #testing }
SYMLAbstractType >> isMetaObjectType [
	^ self == self compilationTarget compilerObjectType
]

{ #category : #testing }
SYMLAbstractType >> isMetaType [
	^ false
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

{ #category : #'accessing method dictionary' }
SYMLAbstractType >> lookupSelector: selector [
	(super lookupSelector: selector) ifNotNil: [ :method | ^ method ].

	self flattenedTraits reverseDo: [ :trait |
		trait methodDictionary at: selector ifPresent: [ :method | ^ method ].
	].
	^ nil
]

{ #category : #accessing }
SYMLAbstractType >> methodDictionary [
	^ methodDictionary
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	| result |
	(name isNil and: [message selector numArgs = 0 and: [self isMetaType not] ]) ifTrue: [
		self name: message selector.
		^ message receiver
	].

	SpecialMetaSymbols at: message selector ifPresent: [ :specialSymbol |
		^ (specialSymbol value: self value: module) analyzeAPSGIdentifierToMe: message inEnvironment: environment.
	].

	(self type lookupSelector: message selector) ifNotNil: [ :method |
		result := method analyzeAndEvaluateMessage: message toReceiver: self inEnvironment: environment at: aPosition.
		^ result asAPSGNodeInEnvironment: environment at: aPosition
	].

	self type lookSymbol: message selector ifPresent: [ :symbol |
		self halt
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLAbstractType >> symbols [
	^ symbols
]

{ #category : #accessing }
SYMLAbstractType >> type [
	<compileTime>
	metaType ifNil: [ 
		metaType := SYMLMetaType new
			module: module;
			instanceType: self;
			yourself
	].
	^ metaType
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
