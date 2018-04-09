Class {
	#name : #SYMLAbstractType,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'usedTraits',
		'symbols',
		'methodDictionary',
		'metaType',
		'flattenedTraits',
		'traitUsers',
		'implicitConversionRules',
		'explicitConversionRules',
		'ssaType',
		'cachedValues',
		'arithmeticCoercionRules'
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
		#macro . [ :programEntity :module | SYMLMetaBuilder for: SYMLMacroBuilder module: module parent: programEntity ].
		#method . [ :programEntity :module | SYMLMetaBuilder for: SYMLMethod module: module parent: programEntity ].
		#message . [ :programEntity :module | SYMLMetaBuilder for: SYMLMessageMethod module: module parent: programEntity ]
	}.
]

{ #category : #initialization }
SYMLAbstractType class >> specialMetaSymbols [
	^ SpecialMetaSymbols
]

{ #category : #adding }
SYMLAbstractType >> addArithmeticCoercionRule: aRule [
	arithmeticCoercionRules add: aRule
]

{ #category : #adding }
SYMLAbstractType >> addMethod: method withSelector: selector [
	methodDictionary at: selector put: method
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

{ #category : #accessing }
SYMLAbstractType >> alignment [
	^ self cachedNullary: #alignment
]

{ #category : #conversions }
SYMLAbstractType >> arithmeticCoerceWith: rightType at: aSourcePosition [
	self == rightType ifTrue: [ ^ self ].
	self flattenedTraits do: [ :trait |
		trait arithmeticCoercionRules do: [ :rule |
			(rule coerce: self with: rightType) ifNotNil: [ :result | ^ result ]
		].
	].

	^ nil
	
]

{ #category : #accessing }
SYMLAbstractType >> arithmeticCoercionRules [
	^ arithmeticCoercionRules
]

{ #category : #conversions }
SYMLAbstractType >> arithmeticCoercionWith: otherTypeValue do: actionValue [
	<compileTime>
	<lazy>
	| otherType action coercionRule |
	otherType := otherTypeValue value.
	action := actionValue value asSysmelCompileTimeFunction.
	
	coercionRule := SYMLTypeCoercionFunctionalRule new
		leftType: self;
		rightType: otherType;
		action: action;
		compilationTarget: self compilationTarget;
		yourself.
	self addArithmeticCoercionRule: coercionRule.
	otherType addArithmeticCoercionRule: coercionRule reversed
]

{ #category : #conversions }
SYMLAbstractType >> arithmeticCoercionWith: otherTypeValue into: resultTypeValue [
	<compileTime>
	<lazy>
	| otherType resultType coercionRule |
	otherType := otherTypeValue value.
	resultType := resultTypeValue value.
	
	coercionRule := SYMLTypeCoercionSimpleRule new
		leftType: self;
		rightType: otherType;
		resultType: resultType;
		yourself.
	self addArithmeticCoercionRule: coercionRule.
	otherType addArithmeticCoercionRule: coercionRule reversed
]

{ #category : #definition }
SYMLAbstractType >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock
]

{ #category : #'code generation' }
SYMLAbstractType >> buildSSAType [
	| result |
	result := (self sysmelPerform: #buildSSAType withArguments: #()) unwrapSysmelValue.
	result ifNil: [ self error: 'Cannot instantiate type {1}.' format: self printString ].
	^ result
]

{ #category : #'type composition' }
SYMLAbstractType >> cachedNullary: selector [
	^ cachedValues at: selector ifAbsentPut: [(self sysmelPerform: selector withArguments: #()) unwrapSysmelValue]
]

{ #category : #conversions }
SYMLAbstractType >> canBeCoercedImplicitlyInto: targetType [
	^ (self coercedImplicitlyInto: targetType) isNotNil
]

{ #category : #conversions }
SYMLAbstractType >> canBeConvertedExplicitlyInto: targetType [
	^ (self convertedExplicitlyInto: targetType) isNotNil
]

{ #category : #conversions }
SYMLAbstractType >> canNode: node beCoercedImplicitlyInto: targetType [
	^ (self node: node coercedImplicitlyInto: targetType) isNotNil
]

{ #category : #conversions }
SYMLAbstractType >> canNode: node beConvertedExplicitlyInto: targetType [
	^ (self node: node convertedExplicitlyInto: targetType) isNotNil
]

{ #category : #'type composition' }
SYMLAbstractType >> cleanType [
	^ self cachedNullary: #cleanType
]

{ #category : #'type composition' }
SYMLAbstractType >> cleanValueType [
	^ cachedValues at: #cleanValueType ifAbsentPut: [self cleanType valueType]
]

{ #category : #conversions }
SYMLAbstractType >> coerceValue: value into: targetType at: coercionPosition [
	(self coercedImplicitlyInto: targetType) ifNil: [
		self error: 'Failed to find implicit conversion from {1} into {2}.' format: { self asString . targetType asString } at: coercionPosition
	] ifNotNil: [ :rule |
		^ rule convertValue: value into: targetType at: coercionPosition
	]
]

{ #category : #conversions }
SYMLAbstractType >> coercedImplicitlyInto: targetType [
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	implicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertFrom: self into: targetType) ifTrue: [ ^ rule ].
	].

	usedTraits do: [ :trait |
		(trait coercedImplicitlyInto: targetType) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
]

{ #category : #conversions }
SYMLAbstractType >> conversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetTypeKind;
					parse: actionRules;
					yourself.
	implicitConversionRules add: conversionRule.
	explicitConversionRules add: conversionRule.
]

{ #category : #conversions }
SYMLAbstractType >> convertedExplicitlyInto: targetType [
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	explicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertFrom: self into: targetType) ifTrue: [ ^ rule ].
	].

	usedTraits do: [ :trait |
		(trait convertedExplicitlyInto: targetType) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
]

{ #category : #'type composition' }
SYMLAbstractType >> cvariadicCoercionType [
	^ self cachedNullary: #cvariadicCoercionType
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

{ #category : #conversions }
SYMLAbstractType >> explicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetTypeKind;
					parse: actionRules;
					yourself.
	explicitConversionRules add: conversionRule.
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

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAValue: value withBuilder: aBuilder [
	| result |
	result := self sysmelPerform: #generateSSAValue:withBuilder: withArguments:  { value . aBuilder }.
	^ result unwrapSysmelValue
]

{ #category : #conversions }
SYMLAbstractType >> implicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetTypeKind;
					parse: actionRules;
					yourself.
	implicitConversionRules add: conversionRule.
]

{ #category : #initialization }
SYMLAbstractType >> initialize [
	super initialize.
	usedTraits := OrderedCollection new.
	traitUsers := WeakSet new.
	symbols := SYMLOrderedDictionary new.
	methodDictionary := SYMLOrderedDictionary new.
	implicitConversionRules := OrderedCollection new.
	explicitConversionRules := OrderedCollection new.
	arithmeticCoercionRules := OrderedCollection new.
	cachedValues := Dictionary new.
]

{ #category : #accessing }
SYMLAbstractType >> invalidateFlattenedTraits [
	flattenedTraits := nil.
	traitUsers do: #invalidateFlattenedTraits
]

{ #category : #testing }
SYMLAbstractType >> isConstantType [
	^ self cachedNullary: #isConstantType
]

{ #category : #testing }
SYMLAbstractType >> isFunctionType [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isLiteralType [
	^ self cachedNullary: #isLiteralType
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
SYMLAbstractType >> isPointerType [
	^ self cachedNullary: #isPointerType
]

{ #category : #testing }
SYMLAbstractType >> isReferenceType [
	^ self cachedNullary: #isReferenceType
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
SYMLAbstractType >> isTupleType [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isType [
	^ true
]

{ #category : #testing }
SYMLAbstractType >> isVoidType [
	^ self == self compilationTarget voidType
]

{ #category : #testing }
SYMLAbstractType >> isVolatileType [
	^ self cachedNullary: #isVolatileType
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

{ #category : #conversions }
SYMLAbstractType >> node: node coercedImplicitlyInto: targetType [
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	implicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertNode: node from: self into: targetType) ifTrue: [ ^ rule ].
	].

	usedTraits do: [ :trait |
		(trait node: node coercedImplicitlyInto: targetType) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
]

{ #category : #conversions }
SYMLAbstractType >> node: node coercedImplicitlyInto: targetType at: aPosition [
	| coercionRule |
	coercionRule := self node: node coercedImplicitlyInto: targetType.
	coercionRule ifNil: [
		self error: 'Cannot coerce value of {1} into {2}.' format: {self asString . targetType asString} at: aPosition
	].
	^ coercionRule
]

{ #category : #conversions }
SYMLAbstractType >> node: node convertedExplicitlyInto: targetType [
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	explicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertNode: node from: self into: targetType) ifTrue: [ ^ rule ].
	].

	usedTraits do: [ :trait |
		(trait node: node convertedExplicitlyInto: targetType) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
]

{ #category : #conversions }
SYMLAbstractType >> node: node convertedExplicitlyInto: targetType at: aPosition [
	| coercionRule |
	coercionRule := self node: node convertedExplicitlyInto: targetType.
	coercionRule ifNil: [
		self error: 'Cannot convert value of {1} into {2}.' format: {self asString . targetType asString} at: aPosition
	].
	^ coercionRule
]

{ #category : #testing }
SYMLAbstractType >> pointed [
	^ self cachedNullary: #pointed
]

{ #category : #'type composition' }
SYMLAbstractType >> pointer [
	^ self cachedNullary: #pointer
]

{ #category : #'type composition' }
SYMLAbstractType >> ref [
	^ self cachedNullary: #ref
]

{ #category : #testing }
SYMLAbstractType >> referenced [
	^ self cachedNullary: #referenced
]

{ #category : #'macro compilation' }
SYMLAbstractType >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| method |
	method := self lookupSelector: message selector.
	method ifNotNil: [
		^ method semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	self isReferenceType ifTrue: [
		^ self valueType semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	(self isMetaObjectType or: [ self isMetaType ]) ifTrue: [
		^ SYMLSendToHost new semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	self error: 'Cannot send message {1} to value of type {2}.' format: { message selector printString . self asString } at: aPosition
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
SYMLAbstractType >> size [
	^ self cachedNullary: #size
]

{ #category : #accessing }
SYMLAbstractType >> ssaType [
	<compileTime>
	ssaType ifNil: [ ssaType := self buildSSAType].
	^ ssaType
]

{ #category : #accessing }
SYMLAbstractType >> symbols [
	^ symbols
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> sysmelPerform: aSelector withArguments: arguments [
	| method result |
	method := (self type lookupSelector: aSelector).
	method ifNil: [
		self error: 'Cannot perform sysmel method {1} with receiver of type {2}.' format: { aSelector printString  . self asString }
	].

	result := method evaluateWithReceiver: self arguments: (arguments collect: [ :arg | arg asSysmelValueInEnvironment: definitionEnvironment ]) inEnvironment: definitionEnvironment at: (SYMLSourcePosition new).
	^ result
]

{ #category : #accessing }
SYMLAbstractType >> type [
	<compileTime>
	metaType ifNil: [ 
		metaType := SYMLMetaType new
			module: module;
			definitionEnvironment: definitionEnvironment;
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

{ #category : #'type composition' }
SYMLAbstractType >> valueType [
	^ self cachedNullary: #valueType
]
