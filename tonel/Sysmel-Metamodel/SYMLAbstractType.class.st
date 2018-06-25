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
		'arithmeticCoercionRules',
		'children',
		'hasDefinition',
		'mangledName',
		'printingName'
	],
	#classVars : [
		'SpecialMetaSymbols'
	],
	#category : #'Sysmel-Metamodel-Type'
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

{ #category : #intrinsics }
SYMLAbstractType >> addIntrinsicField: fieldName slotIndex: slotIndex [
	<compileTime>
	| field |
	field := SYMLFieldVariable new
		module: self module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: self definitionNode;
		parent: self;
		slotIndex: slotIndex;
		yourself.
	field name: fieldName.
	^ field
]

{ #category : #adding }
SYMLAbstractType >> addMacroFunctionPattern: macroMethodPattern withSelector: selector [
	| group |
	group := super addMacroFunctionPattern: macroMethodPattern withSelector: selector.
	
	children add: macroMethodPattern.
	^ group
]

{ #category : #adding }
SYMLAbstractType >> addMacroMethodPattern: macroMethodPattern withSelector: selector [
	| group |
	group := super addMacroMethodPattern: macroMethodPattern withSelector: selector.
	
	children add: macroMethodPattern.
	^ group
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

{ #category : #adding }
SYMLAbstractType >> addTypeKindBaseTrait [
	self typeKindBaseTrait ifNotNil: [ :trait |
		self addTrait: trait.
	]

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

{ #category : #converting }
SYMLAbstractType >> asPointerType [
	^ self cachedNullary: #asPointerType
]

{ #category : #converting }
SYMLAbstractType >> asReceiverType [
	^ self cachedNullary: #asReceiverType fallbackWith: [ self ]
]

{ #category : #converting }
SYMLAbstractType >> asReferenceType [
	^ self cachedNullary: #asReferenceType
]

{ #category : #converting }
SYMLAbstractType >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: self type inEnvironment: anEnvironment
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

{ #category : #'type composition' }
SYMLAbstractType >> cachedNullary: selector fallbackWith: absentBlock [
	^ cachedValues at: selector ifAbsentPut: [(self sysmelPerform: selector withArguments: #() fallbackWith: [ ^ absentBlock value ]) unwrapSysmelValue]
]

{ #category : #'type composition' }
SYMLAbstractType >> cachedUnary: selector arg: argument [
	^ cachedValues at: {selector . argument} ifAbsentPut: [(self sysmelPerform: selector withArguments: {argument}) unwrapSysmelValue]
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
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules;
						yourself.
		implicitConversionRules add: conversionRule.
		explicitConversionRules add: conversionRule.
	]

]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> convertValueToFunctionActivationValue: value at: aPosition [
	^ self sysmelPerform: #convertValueToFunctionActivationValue:at: withArguments: { value . aPosition } fallbackWith: [
		self isMetaObjectType ifTrue: [ value value ] ifFalse: [ value ]
	]
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

{ #category : #'code generation' }
SYMLAbstractType >> defaultSSAValueWith: builder [
	| result |
	result := self sysmelPerform: #defaultSSAValueWith: withArguments:  { builder }.
	^ result unwrapSysmelValue
]

{ #category : #defaults }
SYMLAbstractType >> defaultValue [
	^ self sysmelPerform: #defaultValue withArguments: #()
]

{ #category : #definition }
SYMLAbstractType >> definition: aDefinitionBlock [
	<compileTime>
	<lazy>
	
	| traitScope lexicalScope |
	hasDefinition := true.
	traitScope := self definitionScopeClass parent: aDefinitionBlock environment.
	traitScope programEntity: self.
	
	lexicalScope := SYMLLexicalScope parent: traitScope.
	aDefinitionBlock value analyzeAndEvaluateInEnvironment: lexicalScope.

]

{ #category : #accessing }
SYMLAbstractType >> definitionEnvironment: anEnvironment [
	super definitionEnvironment: anEnvironment.
	anEnvironment ifNotNil: [
		self addTypeKindBaseTrait
	]
]

{ #category : #definition }
SYMLAbstractType >> definitionScopeClass [
	^ SYMLAbstractTypeScope
]

{ #category : #accessing }
SYMLAbstractType >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ self type
]

{ #category : #testing }
SYMLAbstractType >> evaluateReferenceAt: position [
	^ self sysmelValueWithType: self type inEnvironment: nil
]

{ #category : #conversions }
SYMLAbstractType >> explicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules;
						yourself.
		explicitConversionRules add: conversionRule.
	]
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
SYMLAbstractType >> generateSSAReferenceWith: builder [
	^ self type generateSSAValue: self withBuilder: builder
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
		targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules;
						yourself.
		implicitConversionRules add: conversionRule.
	]
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
	children := OrderedCollection new.
	cachedValues := Dictionary new.
	hasDefinition := false.
]

{ #category : #initialization }
SYMLAbstractType >> initializeSSAVariable: ssaVariable builder: builder [
]

{ #category : #accessing }
SYMLAbstractType >> invalidateFlattenedTraits [
	flattenedTraits := nil.
	traitUsers do: #invalidateFlattenedTraits
]

{ #category : #testing }
SYMLAbstractType >> isAPSGNodeType [
	^ self == self compilationTarget apsgNodeType
]

{ #category : #testing }
SYMLAbstractType >> isConstantType [
	^ self cachedNullary: #isConstantType
]

{ #category : #testing }
SYMLAbstractType >> isFloatingPointType [
	^ self cachedNullary: #isFloatingPointType
]

{ #category : #testing }
SYMLAbstractType >> isFunctionType [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isIntegerType [
	^ self cachedNullary: #isIntegerType
]

{ #category : #testing }
SYMLAbstractType >> isLiteralSymbol [
	^ self == self compilationTarget literalSymbolType
]

{ #category : #testing }
SYMLAbstractType >> isLiteralType [
	^ self cachedNullary: #isLiteralType
]

{ #category : #testing }
SYMLAbstractType >> isMetaObjectType [
	^ self == self compilationTarget compilerObjectType or: [ self isSysmelKindOf: self compilationTarget typeTrait ]
]

{ #category : #testing }
SYMLAbstractType >> isMetaType [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isPointerOrReferenceType [
	^ self cachedNullary: #isPointerOrReferenceType
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
SYMLAbstractType >> isReturnedThroughFirstArgument [
	^ self cachedNullary: #isReturnedThroughFirstArgument
]

{ #category : #testing }
SYMLAbstractType >> isShaderStageIO [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isShaderType [
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

{ #category : #'symbol lookup' }
SYMLAbstractType >> lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock [
	<compileTime>
	^ self sysmelPerform: #lookReceiver:symbol:ifPresent: withArguments: { receiver . symbol . ifPresentBlock } fallbackWith: [ nil ]
]

{ #category : #'symbol lookup' }
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
SYMLAbstractType >> mangledName [
	| escapedName |
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPut: $t;
				print: escapedName size;
				nextPutAll: escapedName.
		]
	]
]

{ #category : #accessing }
SYMLAbstractType >> methodDictionary [
	^ methodDictionary
]

{ #category : #adding }
SYMLAbstractType >> methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock [
	^ methodDictionary at: selector ifPresent: presentBlock ifAbsentPut: absentBlock
]

{ #category : #conversions }
SYMLAbstractType >> node: node coercedImplicitlyInto: targetType [
	(node isNotNil and: [node isMetaObjectInstance]) ifTrue: [ 
		self flag: 'FIXME: Remove this case.'.
		node metaObject type == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ]
	].

	^ self node: node coercedImplicitlyInto: targetType visited: IdentitySet new
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
SYMLAbstractType >> node: node coercedImplicitlyInto: targetType visited: visitedSet [
	| chainedRule |
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	(visitedSet includes: self) ifTrue: [ ^ nil ].
	visitedSet add: self.
	
	implicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertNode: node from: self into: targetType) ifTrue: [ ^ rule ].
		rule isTypeKindConversion ifTrue: [ 
			(visitedSet includes: rule targetTypeKind) ifFalse: [
				rule targetTypeKind withAllTraitUsersDo: [ :intermediateType |
					chainedRule := intermediateType node: node coercedImplicitlyInto: targetType visited: visitedSet.
					chainedRule ifNotNil: [ 
						^ rule intermediateConversion: intermediateType chainedWith: chainedRule
					]
				]
			].
		]
	].

	usedTraits do: [ :trait |
		(trait node: node coercedImplicitlyInto: targetType visited: visitedSet) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
]

{ #category : #conversions }
SYMLAbstractType >> node: node convertedExplicitlyInto: targetType [
	^ self node: node convertedExplicitlyInto: targetType visited: IdentitySet new
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

{ #category : #conversions }
SYMLAbstractType >> node: node convertedExplicitlyInto: targetType visited: visitedSet [
	| chainedRule |
	self == targetType ifTrue: [ ^ SYMLIdentityTypeConversionRule new ].
	(visitedSet includes: self) ifTrue: [ ^ nil ].
	visitedSet add: self.
	
	explicitConversionRules do: [ :rule |
		(rule canBeUsedToConvertNode: node from: self into: targetType) ifTrue: [ ^ rule ].
		rule isTypeKindConversion ifTrue: [ 
			(visitedSet includes: rule targetTypeKind) ifFalse: [ 
				rule targetTypeKind withAllTraitUsersDo: [ :intermediateType |
					chainedRule := intermediateType node: node coercedImplicitlyInto: targetType visited: visitedSet.
					chainedRule ifNotNil: [ 
						^ rule intermediateConversion: intermediateType chainedWith: chainedRule
					]
				]
			].
		]
	].

	usedTraits do: [ :trait |
		(trait node: node convertedExplicitlyInto: targetType visited: visitedSet) ifNotNil: [ :rule |
			^ rule
		]
	].

	^ nil
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
SYMLAbstractType >> pointerFor: addressSpace [
	^ self cachedUnary: #pointerFor: arg: addressSpace
]

{ #category : #accessing }
SYMLAbstractType >> printingName [
	<compileTime>
	^ printingName ifNil: [printingName := (self sysmelPerform: #createPrintingName withArguments: #() fallbackWith: [self validName]) unwrapSysmelValue]
]

{ #category : #accessing }
SYMLAbstractType >> printingName: aPrintingName [
	<compileTime>
	printingName := aPrintingName
]

{ #category : #'type composition' }
SYMLAbstractType >> ref [
	^ self cachedNullary: #ref
]

{ #category : #'type composition' }
SYMLAbstractType >> refFor: addressSpace [
	^ self cachedUnary: #refFor: arg: addressSpace
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

	self flag: 'TODO: Remove this reference check.'.
	self isReferenceType ifTrue: [
		^ self valueType semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	(self isMetaObjectType or: [ self isLiteralType ]) ifTrue: [
		^ SYMLSendToHost new semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	self error: 'Cannot send message {1} to value of type {2}.' format: { message selector printString . self asString } at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	(name isNil and: [message selector numArgs = 0 and: [self isMetaType not and: [hasDefinition not] ]]) ifTrue: [
		^ self setName: message selector ifNewReturnNode: message receiver
	].

	SpecialMetaSymbols at: message selector ifPresent: [ :specialSymbol |
		^ (specialSymbol value: self value: module) analyzeAPSGIdentifierToMe: message inEnvironment: environment.
	].

	(self type lookupSelector: message selector) ifNotNil: [ :method |
		^ method analyzeMetaMessage: message toReceiver: self inEnvironment: environment at: aPosition
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
SYMLAbstractType >> ssaValue [
	^ SLVMConstant type: self type ssaType value: 0
]

{ #category : #adding }
SYMLAbstractType >> symbol: aSymbol ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	| newValue |
	^ symbols at: aSymbol ifPresent: ifPresentBlock ifAbsentPut: [
		newValue := ifAbsentBlock value.
		children add: newValue.
		newValue
	].
]

{ #category : #accessing }
SYMLAbstractType >> symbols [
	^ symbols
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> sysmelPerform: aSelector withArguments: arguments [
	^ self sysmelPerform: aSelector withArguments: arguments fallbackWith: [
		self error: 'Cannot perform sysmel method {1} with receiver of type {2}.' format: { aSelector printString  . self asString }
	]

]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> sysmelPerform: aSelector withArguments: arguments fallbackWith: fallbackBlock [
	| method result |
	method := (self type lookupSelector: aSelector).
	method ifNil: [
		^ fallbackBlock value
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

{ #category : #'as yet unclassified' }
SYMLAbstractType >> typeKindBaseTrait [
	^ nil
]

{ #category : #'type composition' }
SYMLAbstractType >> union: variantAlternative [
	<compileTime>
	^ self compilationTarget variantTypes: { self . variantAlternative }
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

{ #category : #enumerating }
SYMLAbstractType >> variantAlternativesDo: aBlock [
	aBlock value: self
]

{ #category : #enumerating }
SYMLAbstractType >> withAllTraitUsersDo: aBlock [
	aBlock value: self.
	traitUsers do: aBlock
]

{ #category : #'type composition' }
SYMLAbstractType >> | variantAlternative [
	<compileTime>
	^ self union: variantAlternative
]
