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
		'printingName',
		'metaClassClass',
		'slots',
		'ssaTypeInfo',
		'reinterpretConversionRules'
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
		#message . [ :programEntity :module | SYMLMetaBuilder for: SYMLMessageMethod module: module parent: programEntity ].
		
		#virtual . [ :programEntity :module | (SYMLMethodMetaBuilderFlags module: module parent: programEntity) virtual ].
		#override . [ :programEntity :module | (SYMLMethodMetaBuilderFlags module: module parent: programEntity) override ].
		#final . [ :programEntity :module | (SYMLMethodMetaBuilderFlags module: module parent: programEntity) final ].
	}.
]

{ #category : #initialization }
SYMLAbstractType class >> specialMetaSymbols [
	^ SpecialMetaSymbols
]

{ #category : #'type composition' }
SYMLAbstractType >> => aReturnType [
	<compileTime>
	self isVoidType ifTrue: [
		^ self compilationTarget functionArguments: #() returnType: aReturnType.
	].
	^ self compilationTarget functionArguments: { self } returnType: aReturnType.

]

{ #category : #adding }
SYMLAbstractType >> addArithmeticCoercionRule: aRule [
	arithmeticCoercionRules add: aRule
]

{ #category : #conversions }
SYMLAbstractType >> addConversionRule: aConversionRule [
	<compileTime>
	self
		addImplicitConversionRule: aConversionRule;
		addExplicitConversionRule: aConversionRule
]

{ #category : #hooks }
SYMLAbstractType >> addConversionRulesToPointerTypeToMyself: referenceType [
	<compileTime>
]

{ #category : #hooks }
SYMLAbstractType >> addConversionRulesToReferenceTypeToMyself: referenceType [
	<compileTime>
]

{ #category : #conversions }
SYMLAbstractType >> addDefaultConversionRules [
	self
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:source :target |
			source == target
		]); 
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:node :source :target |
			node isNotNil and: [node isMetaObjectInstance and: [node metaObject type == target]]
		]);
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:source :target |
			target == self compilationTarget compilerObjectType
		])
]

{ #category : #conversions }
SYMLAbstractType >> addExplicitConversionRule: aConversionRule [
	<compileTime>
	explicitConversionRules add: aConversionRule
]

{ #category : #conversions }
SYMLAbstractType >> addImplicitConversionRule: aConversionRule [
	<compileTime>
	implicitConversionRules add: aConversionRule
]

{ #category : #intrinsics }
SYMLAbstractType >> addIntrinsicField: fieldName slotIndex: slotIndex [
	<compileTime>
	| field |
	field := self fieldMetaobjectClass new
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
	(macroMethodPattern isVirtual or: [macroMethodPattern isOverride]) ifTrue: [
		self addVirtualTableEntry: macroMethodPattern
	].

	^ group
]

{ #category : #adding }
SYMLAbstractType >> addMacroMethodPattern: macroMethodPattern withSelector: selector [
	| group |
	group := super addMacroMethodPattern: macroMethodPattern withSelector: selector.
	
	children add: macroMethodPattern.
	(macroMethodPattern isVirtual or: [macroMethodPattern isOverride]) ifTrue: [
		self addVirtualTableEntry: macroMethodPattern
	].

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

{ #category : #'virtual table' }
SYMLAbstractType >> addVirtualTableEntry: anAbstractFunction [
	self error: 'Cannot add virtual methods to type {1}.' format: { self printString } at: anAbstractFunction definitionPosition
]

{ #category : #conversions }
SYMLAbstractType >> allConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules asBlockDictionaryValue;
						yourself.
		implicitConversionRules add: conversionRule.
		explicitConversionRules add: conversionRule.
		reinterpretConversionRules add: conversionRule.
	]

]

{ #category : #'macro compilation' }
SYMLAbstractType >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	^ (self semanticAnalyzeMessage: message inEnvironment: environment at: aPosition) evaluateInEnvironment: environment
]

{ #category : #conversions }
SYMLAbstractType >> arithmeticCoerceNode: node withType: rightType node: rightNode at: aSourcePosition [
	self == rightType ifTrue: [ ^ self ].
	self flattenedTraits do: [ :trait |
		trait arithmeticCoercionRules do: [ :rule |
			(rule coerce: self node: node with: rightType node: rightNode) ifNotNil: [ :result | ^ result ]
		].
	].

	^ nil
	
]

{ #category : #conversions }
SYMLAbstractType >> arithmeticCoerceWith: rightType at: aSourcePosition [
	^ self arithmeticCoerceNode: nil withType: rightType node: nil at: aSourcePosition
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
SYMLAbstractType >> asConcreteTypeForFunctionAnalysis [
	^ self cachedNullary: #asConcreteTypeForFunctionAnalysis fallbackWith: [ self ]
]

{ #category : #'type composition' }
SYMLAbstractType >> asGCClassFieldType [
	^ self cachedNullary: #asGCClassFieldType fallbackWith: [ self ]
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
SYMLAbstractType >> asReturnTypeForReceiverType: callReceiverType argumentTypes: callArgumentTypes [
	cachedValues at: #asReturnTypeForReceiverType:argumentTypes: ifPresent: [ :cached | ^ cached ].
	^ (self sysmelPerform: #asReturnTypeForReceiverType:argumentTypes: withArguments: {callReceiverType . callArgumentTypes} fallbackWith: [
		cachedValues at: #asReturnTypeForReceiverType:argumentTypes: put: self.
		self
	]) unwrapSysmelValue
]

{ #category : #converting }
SYMLAbstractType >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: self type inEnvironment: anEnvironment
]

{ #category : #'type composition' }
SYMLAbstractType >> asVariableValueType [
	^ self cachedNullary: #asVariableValueType fallbackWith: [ self ]
]

{ #category : #definition }
SYMLAbstractType >> assignValue: aDefinitionBlock [
	<compileTime>
	<lazy>
	^ self definition: aDefinitionBlock asFunctionalValue
]

{ #category : #'code generation' }
SYMLAbstractType >> basicInitializeSSAVariable: ssaVariable with: builder [
	| result |
	result := self sysmelPerform: #basicInitializeSSAVariable:with: withArguments:  { ssaVariable . builder }.
	^ result unwrapSysmelValue
]

{ #category : #'code generation' }
SYMLAbstractType >> buildSSAType [
	| result |
	result := (self sysmelPerform: #buildSSAType withArguments: #()) unwrapSysmelValue.
	result ifNil: [ self error: 'Cannot instantiate type {1}.' format: self printString ].
	^ result
]

{ #category : #conversions }
SYMLAbstractType >> buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes [
	| previousTypeAndRule previousType rule previousRule |
	previousTypeAndRule := visitedTypes at: targetType.
	previousTypeAndRule ifNil: [ ^ nil ].
	
	previousType := previousTypeAndRule first.
	rule := previousTypeAndRule second.
	previousType == targetType ifTrue: [ ^ rule ].
	previousType ifNil: [ ^ rule ].
	
	previousRule := self buildTypeConversionChainUntil: previousType fromVisitedTypes: visitedTypes.
	previousRule ifNil: [ ^ rule ].
	
	^ previousRule intermediateConversion: previousType chainedWith: rule
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

{ #category : #'initialization finalization' }
SYMLAbstractType >> checkNonTrivialBasicInitialization [
	^ methodDictionary at: #basicInitialize
		ifPresent: #isNonTrivialConstructorOrDestructor
		ifAbsent: [ false ]
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> checkNonTrivialFinalization [
	^ methodDictionary at: #finalize
		ifPresent: #isNonTrivialConstructorOrDestructor
		ifAbsent: [ false ]
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> checkNonTrivialInitialization [
	^ methodDictionary at: #initialize
		ifPresent: #isNonTrivialConstructorOrDestructor
		ifAbsent: [ false ]
]

{ #category : #'type composition' }
SYMLAbstractType >> cleanType [
	^ self cachedNullary: #cleanType
]

{ #category : #'type composition' }
SYMLAbstractType >> cleanValueType [
	^ cachedValues at: #cleanValueType ifAbsentPut: [self cleanType valueType]
]

{ #category : #'type composition' }
SYMLAbstractType >> cleanValueTypeKeepLiteral [
	^ cachedValues at: #cleanValueTypeKeepLiteral ifAbsentPut: [self cleanType valueTypeKeepLiteral]
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
	^ self node: nil coercedImplicitlyInto: targetType
]

{ #category : #accessing }
SYMLAbstractType >> concreteSSAType [
	<compileTime>
	^ self ssaType
]

{ #category : #'type composition' }
SYMLAbstractType >> const [
	^ self cachedNullary: #const
]

{ #category : #conversions }
SYMLAbstractType >> conversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules asBlockDictionaryValue;
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
	^ self node: nil convertedExplicitlyInto: targetType
]

{ #category : #conversions }
SYMLAbstractType >> convertedReinterpretingInto: targetType [
	^ self node: nil convertedReinterpretingInto: targetType
]

{ #category : #accessing }
SYMLAbstractType >> createMetaType [
	| newMetaType |
	newMetaType := metaClassClass ifNil: [ 
		SYMLSimpleMetaType new
			module: module;
			definitionEnvironment: definitionEnvironment;
			instanceType: self;
			yourself
	] ifNotNil: [
		metaClassClass createMetaTypeFor: self basingOf: metaType
	].
	self assert: newMetaType isMetaType.
	metaType ifNil: [
		metaType := newMetaType
	] ifNotNil: [
		metaType becomeForward: newMetaType
	].
	
	self invalidateCachedValues
]

{ #category : #accessing }
SYMLAbstractType >> createTypeInfoSlots [
	slots := self type createTypeInstanceSlotsFor: self.
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
	aDefinitionBlock node analyzeAndEvaluateInEnvironment: lexicalScope.

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

{ #category : #testing }
SYMLAbstractType >> elementType [
	^ self cachedNullary: #elementType
]

{ #category : #accessing }
SYMLAbstractType >> ensureConcreteStructureSSAType [
]

{ #category : #accessing }
SYMLAbstractType >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ self type
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> evaluateReceiver: receiverValue field: field withType: fieldType at: position [
	fieldType == field type ifTrue: [ 
		^ (receiverValue slots at: field slotIndex + 1) sysmelValueWithType: field type inEnvironment: definitionEnvironment
	].

	(fieldType isReferenceType and: [ fieldType referenced == field type ]) ifTrue: [ 
		^ (SYMLReceiverFieldReference new
			container: receiverValue;
			field: field;
			type: fieldType;
			yourself) asSysmelValueInEnvironment: definitionEnvironment
	].
	
	self error: 'Cannot evaluate field {1}' format: { field name } at: position
]

{ #category : #testing }
SYMLAbstractType >> evaluateReferenceAt: position [
	^ self sysmelValueWithType: self type inEnvironment: nil
]

{ #category : #accessing }
SYMLAbstractType >> explicitConversionRules [
	^ explicitConversionRules
]

{ #category : #conversions }
SYMLAbstractType >> explicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules asBlockDictionaryValue;
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
SYMLAbstractType >> fieldMetaobjectClass [
	^ SYMLFieldVariable
]

{ #category : #'code generation' }
SYMLAbstractType >> finalizeSSAVariable: ssaVariable with: builder [
	| result |
	result := self sysmelPerform: #finalizeSSAVariable:with: withArguments:  { ssaVariable . builder}.
	^ result unwrapSysmelValue
]

{ #category : #conversions }
SYMLAbstractType >> findConversionRuleInto: targetType node: node rulesExtractor: rulesExtractor [
	| visitedTypes pendingTypes currentTypeFromToCheck currentType incomingTypeAndRule |
	visitedTypes := IdentityDictionary new.
	pendingTypes := LinkedList new.
	
	pendingTypes add: { self . nil }.
	
	[ pendingTypes isEmpty ] whileFalse: [ 
		currentTypeFromToCheck := pendingTypes first.
		pendingTypes removeFirst.
		
		currentType := currentTypeFromToCheck first.
		incomingTypeAndRule := currentTypeFromToCheck second.
		
		(visitedTypes includesKey: currentType) ifTrue: [
			(currentType == targetType and: [ incomingTypeAndRule isNotNil ]) ifTrue: [ 
				targetType name = 'CompiledMethod' ifTrue: [self halt].
				^ self buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes
			].
		] ifFalse: [ 
			"Ignore the types that were already visited."
			visitedTypes at: currentType put: incomingTypeAndRule.
		
			(rulesExtractor value: currentType) do: [ :rule |
				(rule canBeUsedToConvertNode: node from: currentType into: targetType) ifTrue: [
					visitedTypes at: targetType put: {currentType . rule}.
					^ self buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes
				].
			
				rule isTypeKindConversion ifTrue: [
					rule targetTypeKind withAllTraitUsersDo: [ :nextType |
						(visitedTypes includesKey: nextType) ifFalse: [
							pendingTypes addLast: { nextType . { currentType . rule } }.
						]
					]
				]
			].
		
			currentType usedTraits do: [ :trait |
				(visitedTypes includesKey: trait) ifFalse: [
					pendingTypes addLast: { trait . { currentType . SYMLIdentityTypeConversionRule new } }.
				]
			]
		]
	].

	^ nil
]

{ #category : #accessing }
SYMLAbstractType >> flattenTraitsInto: target visited: visited [
	(visited includes: self) ifTrue: [ ^ self ].
	visited add: self.
	
	usedTraits do: [ :trait | trait flattenTraitsInto: target visited: visited ].
	self supertype ifNotNil: [ :st |
		st flattenTraitsInto: target visited: visited
	].
	target add: self.
	
]

{ #category : #accessing }
SYMLAbstractType >> flattenedTraits [
	flattenedTraits ifNotNil: [ ^ flattenedTraits ].
	flattenedTraits := OrderedCollection new.
	self flattenTraitsInto: flattenedTraits visited: IdentitySet new.
	self assert: flattenedTraits last == self.
	flattenedTraits := flattenedTraits asArray.
	^ flattenedTraits
]

{ #category : #'reflection metadata proxies' }
SYMLAbstractType >> gcLayoutReflectionProxy [
	^ SYMLGCLayoutReflectionProxy for: self
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSACode [
	self ssaTypeInfo.
	(self isMetaType not and: [ metaType isNotNil ]) ifTrue: [metaType generateSSACode]
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAConstant: value forModule: aModule [
	| result |
	result := self sysmelPerform: #generateSSAConstant:forModule: withArguments:  { value . aModule}.
	^ result unwrapSysmelValue
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAImplicitBasicInitializationFor: receiver with: builder [
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAImplicitFinalizationFor: receiver with: builder [
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAImplicitInitializationFor: receiver with: builder [
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAReferenceWith: builder [
	^ self ssaTypeInfo
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSATypeInfo [
	^ self type generateSSATypeInfoForInstance: self
]

{ #category : #'code generation' }
SYMLAbstractType >> generateSSAValue: value withBuilder: aBuilder [
	| result |
	result := self sysmelPerform: #generateSSAValue:withBuilder: withArguments:  { value . aBuilder }.
	^ result unwrapSysmelValue
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> generateSSAValueForModule: aModule [
	^ self ssaTypeInfo
]

{ #category : #testing }
SYMLAbstractType >> hasDynamicMessageSends [
	^ self cachedNullary: #hasDynamicMessageSends fallbackWith: [ false ]
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> hasNonTrivialBasicInitialization [
	^ self cachedNullary: #hasNonTrivialBasicInitialization
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> hasNonTrivialFinalization [
	^ self cachedNullary: #hasNonTrivialFinalization
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> hasNonTrivialGCBasicInitialization [
	^ self cachedNullary: #hasNonTrivialGCBasicInitialization
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> hasNonTrivialGCFinalization [
	^ self cachedNullary: #hasNonTrivialGCFinalization
]

{ #category : #testing }
SYMLAbstractType >> hasNonTrivialGCInitialization [
	^ self cachedNullary: #hasNonTrivialGCInitialization
]

{ #category : #'initialization finalization' }
SYMLAbstractType >> hasNonTrivialInitialization [
	^ self cachedNullary: #hasNonTrivialInitialization
]

{ #category : #accessing }
SYMLAbstractType >> implicitConversionRules [
	^ implicitConversionRules
]

{ #category : #conversions }
SYMLAbstractType >> implicitConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
		targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules asBlockDictionaryValue;
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
	reinterpretConversionRules := OrderedCollection new.
	arithmeticCoercionRules := OrderedCollection new.
	children := OrderedCollection new.
	cachedValues := Dictionary new.
	hasDefinition := false.
	self addDefaultConversionRules
]

{ #category : #'code generation' }
SYMLAbstractType >> initializeSSAVariable: ssaVariable with: builder [
	| result |
	result := self sysmelPerform: #initializeSSAVariable:with: withArguments:  { ssaVariable . builder }.
	^ result unwrapSysmelValue
]

{ #category : #accessing }
SYMLAbstractType >> instanceAlignment [
	^ self cachedNullary: #instanceAlignment
]

{ #category : #accessing }
SYMLAbstractType >> instanceSize [
	^ self cachedNullary: #instanceSize
]

{ #category : #accessing }
SYMLAbstractType >> invalidateCachedValues [
	cachedValues removeAll
]

{ #category : #accessing }
SYMLAbstractType >> invalidateFlattenedTraits [
	flattenedTraits ifNil: [ ^ self ].
	flattenedTraits := nil.
	traitUsers do: #invalidateFlattenedTraits.
	metaType ifNotNil: [ metaType invalidateFlattenedTraits ]
]

{ #category : #testing }
SYMLAbstractType >> isAPSGNodeType [
	^ self == self compilationTarget apsgNodeType
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> isAnonymousType [
	^ false
]

{ #category : #testing }
SYMLAbstractType >> isAnyDynamicObjectType [
	^ self cachedNullary: #isAnyDynamicObjectType
]

{ #category : #testing }
SYMLAbstractType >> isCompileTimeByDefault [
	^ true
]

{ #category : #testing }
SYMLAbstractType >> isCompilerObjectType [
	^ self == self compilationTarget compilerObjectType 
]

{ #category : #testing }
SYMLAbstractType >> isConstantType [
	^ self cachedNullary: #isConstantType
]

{ #category : #testing }
SYMLAbstractType >> isDynamicObjectType [
	^ self cachedNullary: #isDynamicObjectType
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
SYMLAbstractType >> isGCClassVariableDataArrayType [
	^ self cachedNullary: #isGCClassVariableDataArrayType
]

{ #category : #testing }
SYMLAbstractType >> isInstanceOfTemplate: aTemplate [
	^ parent isNotNil and: [ parent isTemplateInstance and: [ parent isInstanceOfTemplate: aTemplate ] ]
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
SYMLAbstractType >> isPODType [
	^ self cachedNullary: #isPODType
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
SYMLAbstractType >> isSigned [
	^ self cachedNullary: #isSigned
]

{ #category : #testing }
SYMLAbstractType >> isSysmelKindOf: anotherType [
	self == anotherType ifTrue: [ ^ true ].
	usedTraits do: [ :used |
		(used isSysmelKindOf: anotherType) ifTrue: [ ^ true ].
	].
	self supertype ifNotNil: [:st | ^ st isSysmelKindOf: anotherType ].
	^ false
	
]

{ #category : #testing }
SYMLAbstractType >> isSysmelReinterpretKindOf: anotherType [
	self flag: 'Move this towards the language side.'.
	self == anotherType ifTrue: [ ^ true ].

	^ false
	
]

{ #category : #testing }
SYMLAbstractType >> isSysmelTrait [
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
SYMLAbstractType >> isUndefinedType [
	^ self cachedNullary: #isUndefinedType
]

{ #category : #testing }
SYMLAbstractType >> isUndeterminedArrayType [
	^ self cachedNullary: #isUndeterminedArrayType
]

{ #category : #testing }
SYMLAbstractType >> isUnsigned [
	^ self cachedNullary: #isUnsigned
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
SYMLAbstractType >> lookupCompileTimeSelector: selector [
	^ self type lookupSelector: selector
]

{ #category : #'accessing method dictionary' }
SYMLAbstractType >> lookupSelector: selector [
	(super lookupSelector: selector) ifNotNil: [ :method | ^ method ].

	self flattenedTraits reverseDo: [ :trait |
		trait methodDictionary at: selector ifPresent: [ :method | ^ method ].
	].

	self supertype ifNotNil: [ :st | ^ st lookupSelector: selector ].
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
SYMLAbstractType >> metaClassClass [
	<compileTime>
	^ metaClassClass
]

{ #category : #accessing }
SYMLAbstractType >> metaClassClass: aMetaClassClass [
	<compileTime>
	metaClassClass == aMetaClassClass ifTrue: [^ self].
	metaClassClass := aMetaClassClass.
	(self isMetaType not and: [metaType isNotNil]) ifTrue: [ self createMetaType ]
]

{ #category : #accessing }
SYMLAbstractType >> methodDictionary [
	^ methodDictionary
]

{ #category : #'reflection metadata proxies' }
SYMLAbstractType >> methodDictionaryReflectionProxy [
	^ SYMLMethodDictionaryReflectionProxy for: self
]

{ #category : #adding }
SYMLAbstractType >> methodWithSelector: selector ifPresent: presentBlock ifAbsentPut: absentBlock [
	^ methodDictionary at: selector ifPresent: presentBlock ifAbsentPut: absentBlock
]

{ #category : #conversions }
SYMLAbstractType >> node: node coercedImplicitlyInto: targetType [
	^ self findConversionRuleInto: targetType node: node rulesExtractor: #implicitConversionRules
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
	^ self findConversionRuleInto: targetType node: node rulesExtractor: #explicitConversionRules

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
SYMLAbstractType >> node: node convertedReinterpretingInto: targetType [
	^ self findConversionRuleInto: targetType node: node rulesExtractor: #reinterpretConversionRules

]

{ #category : #conversions }
SYMLAbstractType >> node: node convertedReinterpretingInto: targetType at: aPosition [
	| coercionRule |
	coercionRule := self node: node convertedReinterpretingInto: targetType.
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

{ #category : #accessing }
SYMLAbstractType >> reinterpretConversionRules [
	^ reinterpretConversionRules
]

{ #category : #conversions }
SYMLAbstractType >> reinterpretConversionTo: targetTypeKindLazyValue doOn: actionRules [
	<compileTime>
	<lazy>
	| targetTypeKind conversionRule |
	targetTypeKind := targetTypeKindLazyValue value.
	targetTypeKind variantAlternativesDo: [ :targetVariantAlternative |
		conversionRule := SYMLTypeKindConversionRule new targetTypeKind: targetVariantAlternative;
						parse: actionRules asBlockDictionaryValue;
						yourself.
		reinterpretConversionRules add: conversionRule.
	]
]

{ #category : #'semantic analysis' }
SYMLAbstractType >> semanticAnalysis [
	(self isMetaType not and: [ metaType isNotNil ]) ifTrue: [metaType semanticAnalysis]
]

{ #category : #'macro compilation' }
SYMLAbstractType >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| method |
	method := nil.
	self flag: 'TODO: Remove this hack'.
	((#(basicInitialize initialize finalize) includes: message selector) and: [self isReferenceType]) ifFalse: [ 
		method := self lookupSelector: message selector.
		method ifNotNil: [
			^ method semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
		].
	].

	self flag: 'TODO: Remove this reference check.'.
	self isReferenceType ifTrue: [
		^ self valueType semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	(self isMetaObjectType or: [ self isLiteralType or: [ self isAPSGNodeType ]]) ifTrue: [
		^ SYMLSendToHost new semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
	].

	self error: 'Cannot send message {1} to value of type {2}.' format: { message selector printString . self asString } at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractType >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	self isAnonymousType ifFalse: [ 
		(name isNil and: [message selector numArgs = 0 and: [self isMetaType not and: [hasDefinition not] ]]) ifTrue: [
			^ self setName: message selector ifNewReturnNode: message receiver
		].
	].

	SpecialMetaSymbols at: message selector ifPresent: [ :specialSymbol |
		^ (specialSymbol value: self value: module) analyzeAPSGIdentifierToMe: message inEnvironment: environment.
	].

	(self type lookupSelector: message selector) ifNotNil: [ :method |
		^ method analyzeMetaMessage: message toReceiver: self inEnvironment: environment at: aPosition
	].

	symbols at: message selector ifPresent: [ :value |
		| identifier |
		identifier := SYMLAPSGIdentifier new
			position: message;
			value: message selector;
			yourself.
		^ value analyzeAPSGIdentifierToMe: identifier inEnvironment: environment
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #accessing }
SYMLAbstractType >> slots [
	slots ifNil: [ self createTypeInfoSlots ].
	^ slots
]

{ #category : #accessing }
SYMLAbstractType >> ssaType [
	<compileTime>
	^ ssaType ifNil: [ ssaType := self buildSSAType]
]

{ #category : #accessing }
SYMLAbstractType >> ssaTypeInfo [
	^ ssaTypeInfo ifNil: [ssaTypeInfo := self generateSSATypeInfo]
]

{ #category : #accessing }
SYMLAbstractType >> ssaTypeInfo: aSSAValue [
	ssaTypeInfo := aSSAValue
]

{ #category : #accessing }
SYMLAbstractType >> supertype [
	^ nil
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

{ #category : #'type composition' }
SYMLAbstractType >> tupleOfSize: tupleSize [
	<compileTime>
	^ self compilationTarget tuple: ((1 to: tupleSize) collect: [ :i | self ])
]

{ #category : #'type composition' }
SYMLAbstractType >> tupleOrScalarOfSize: tupleSize [
	<compileTime>
	tupleSize = 1 ifTrue: [ ^ self ].
	^ self tupleOfSize: tupleSize
]

{ #category : #accessing }
SYMLAbstractType >> type [
	<compileTime>
	metaType ifNil: [ self createMetaType ].
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

{ #category : #'type composition' }
SYMLAbstractType >> valueTypeKeepLiteral [
	^ self cachedNullary: #valueTypeKeepLiteral
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

{ #category : #enumerating }
SYMLAbstractType >> withAllUsedReverseTraitsDo: aBlock [
	aBlock value: self.
	self flattenedTraits reverseDo: aBlock
]

{ #category : #enumerating }
SYMLAbstractType >> withAllUsedTraitsDo: aBlock [
	aBlock value: self.
	self flattenedTraits do: aBlock
]

{ #category : #writing }
SYMLAbstractType >> writeTypedSelectorDataInto: out omitReceiver: omitReceiver [
	out nextPutAll: self printingName
]

{ #category : #'type composition' }
SYMLAbstractType >> | variantAlternative [
	<compileTime>
	^ self union: variantAlternative
]
