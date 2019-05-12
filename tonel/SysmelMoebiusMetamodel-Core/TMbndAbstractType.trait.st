"
I provide the fundamental protocol for the MoebiusBand type system. I am the core of this Meta Object Protocol that expands the Smalltalk MOP with macros, and primitive types.
"
Trait {
	#name : #TMbndAbstractType,
	#instVars : [
		'publicMetaBuilderFactories'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #converting }
TMbndAbstractType >> addConversionRule: conversionRule [
	self
		addExplicitConversionRule: conversionRule;
		addImplicitConversionRule: conversionRule
]

{ #category : #converting }
TMbndAbstractType >> addConversionTo: targetType rule: conversionRule [
	self
		addExplicitConversionTo: targetType rule: conversionRule;
		addImplicitConversionTo: targetType rule: conversionRule
]

{ #category : #adding }
TMbndAbstractType >> addDefaultConversionRules [
	self
		addConversionRule: (MbndIdentityTypeConversionRule when: [:source :target |
			source == target
		]);
		addConversionRule: (MbndIdentityTypeConversionRule when: [:source :target |
			target == self compilationTarget compilerObjectType
		])
]

{ #category : #converting }
TMbndAbstractType >> addExplicitConversionRule: conversionRule [
	self explicitRequirement
]

{ #category : #converting }
TMbndAbstractType >> addExplicitConversionTo: targetType rule: conversionRule [
	targetType isVariantUnionType ifTrue: [ 
		targetType components do: [ :comp |
			self addExplicitConversionTo: comp rule: conversionRule
		].
	
		^ self
	].

	self addExplicitConversionRule: (conversionRule asMbndTypeConversionRuleTo: targetType)
]

{ #category : #converting }
TMbndAbstractType >> addImplicitConversionRule: conversionRule [
	self explicitRequirement
]

{ #category : #converting }
TMbndAbstractType >> addImplicitConversionTo: targetType rule: conversionRule [
	targetType isVariantUnionType ifTrue: [ 
		targetType components do: [ :comp |
			self addImplicitConversionTo: comp rule: conversionRule
		].
	
		^ self
	].

	self addImplicitConversionRule: (conversionRule asMbndTypeConversionRuleTo: targetType)
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> allSubtypes [
	| result |
	result := OrderedCollection new.
	self allSubtypesDo: [ :st | result add: st ].
	^ result
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> allSubtypesDo: aBlock [
	self subtypes do: [ :st | st withAllSubtypesDo: aBlock ]
]

{ #category : #accessing }
TMbndAbstractType >> allTraitUsersDo: aBlock [
	"By default, do nothing"
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeExpandedMessageSendNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeMessageSendNodeWithDynamicSelector: node with: analyzer [
	self error: 'Cannout perform message to value of type {1}.' format: {self fullName} at: node
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode
		position: referenceNode;
		yourself
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	self error: 'Cannot send unknown message {1} to value of type {2}.' format: {node selector printValueString. self fullName} at: node
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector macroMethod |
	node selector isLiteralSymbolValueNode ifTrue: [
		selector := node selector value.
		macroMethod := self lookupMacroSelector: selector.
		macroMethod ifNotNil: [
			^ macroMethod expandMessageNode: node with: analyzer
		].
	
		^ self analyzeUnboundUnexpandedMessageSendNode: node with: analyzer
	].

	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> arithmeticCoercionWith: rightType [
	^ self compilationTarget computeArithmeticCoercionTypeFor: self with: rightType
]

{ #category : #converting }
TMbndAbstractType >> asCVariadicType [
	^ self asCVariadicTypeRequiredAt: MbndSourcePosition new
]

{ #category : #converting }
TMbndAbstractType >> asCVariadicTypeRequiredAt: aPosition [
	self error: 'Cannot pass value of type {1} as a C variadic argument.' format: { self fullName } at: aPosition
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: self type;
		yourself
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ self asLiteralValueNode
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes [
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

{ #category : #'as yet unclassified' }
TMbndAbstractType >> conditionalResultCoercionTypeWith:rightType [
	^ self compilationTarget computeConditionalResultCoercionTypeFor: self with: rightType
]

{ #category : #'type composition' }
TMbndAbstractType >> const [
	<compileTime>
	^ self withDecoration: #const
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> createPublicMetaBuilderFactories [
	^ Dictionary newFromPairs: { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#message . MbndMessageMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	}
]

{ #category : #'default values' }
TMbndAbstractType >> defaultValue [
	self explicitRequirement

]

{ #category : #'default values' }
TMbndAbstractType >> defaultValueASTNode [
	^ self defaultValue asLiteralValueNode

]

{ #category : #converting }
TMbndAbstractType >> findConversionRuleInto: targetType node: node rulesExtractor: rulesExtractor [
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
					pendingTypes addLast: { trait . { currentType . MbndIdentityTypeConversionRule new } }.
				]
			]
		]
	].

	^ nil
]

{ #category : #accessing }
TMbndAbstractType >> fullName [
	self explicitRequirement
]

{ #category : #'type inference' }
TMbndAbstractType >> inferValueTypeForNode: initialValueNode inScope: scope [
	^ self
]

{ #category : #sizes }
TMbndAbstractType >> instanceAlignment [
	^ self explicitRequirement
]

{ #category : #sizes }
TMbndAbstractType >> instanceSize [
	^ self explicitRequirement
]

{ #category : #'testing methods' }
TMbndAbstractType >> isASTNodeType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isAcceptableLiteralValue: literalValue [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isAggregateType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isCompilerObjectType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isConstantType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isDecorationType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isDerivedType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isFunctionType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isFunctionalType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanFalseType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanTrueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralCharacterType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralFloatType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralIntegerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralNumberType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralStringType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralSymbolType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralValueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isMbndType [
	^ true
]

{ #category : #'testing methods' }
TMbndAbstractType >> isMetaBuilderInstanceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isMetaType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isNamespaceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isOpaqueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPointerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveBooleanType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveFloatType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveIntegerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveNumberType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isReferenceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isReturnType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isStructureType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTrait [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isUndefinedType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isUnionType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isVariantUnionType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isVoidType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isVolatileType [
	^ false
]

{ #category : #testing }
TMbndAbstractType >> legalizeLiteralValue: literalValue [
	^ literalValue
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> lookupMacroSelector: aSelector [
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #methods }
TMbndAbstractType >> lookupOverloadedSelector: selector [
	^ self supertype ifNotNil: [ :st | st lookupOverloadedSelector: selector ]
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> lookupPublicMetaBuilderFactoryNamed: name withAnalyzer: analyzer [
	^ self publicMetaBuilderFactories at: name ifAbsent: [ nil ]
]

{ #category : #methods }
TMbndAbstractType >> lookupSelector: aSelector [
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #methods }
TMbndAbstractType >> lookupSymbol: aSymbol [
	aSymbol == #SelfType ifTrue: [ ^ self ].
	^ self supertype ifNotNil: [ :st | st lookupSymbol: aSymbol ]
]

{ #category : #converting }
TMbndAbstractType >> node: node convertedExplicitlyInto: targetType [
	^ self findConversionRuleInto: targetType node: node rulesExtractor: #explicitConversionRules

]

{ #category : #converting }
TMbndAbstractType >> node: node convertedImplicitlyInto: targetType [
	^ self findConversionRuleInto: targetType node: node rulesExtractor: #implicitConversionRules
]

{ #category : #'type composition' }
TMbndAbstractType >> pointer [
	<compileTime>
	^ self compilationTarget pointerTo: self
]

{ #category : #'type composition' }
TMbndAbstractType >> pointerFor: addressSpace [
	<compileTime>
	^ self compilationTarget pointerFor: addressSpace to: self
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> publicMetaBuilderFactories [
	^ publicMetaBuilderFactories ifNil: [ publicMetaBuilderFactories := self createPublicMetaBuilderFactories ]
]

{ #category : #'type composition' }
TMbndAbstractType >> ref [
	<compileTime>
	^ self compilationTarget referenceTo: self
]

{ #category : #'type composition' }
TMbndAbstractType >> refFor: addressSpace [
	<compileTime>
	^ self compilationTarget referenceFor: addressSpace to: self
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypeAdded: aSubtype [
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypeRemoved: aSubtype [
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypes [
	^ #()
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypesDo: aBlock [
	self subtypes do: aBlock
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> supertype [
	"I answer a supertype." 
	^ nil
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> type [
	"I answer a meta type."
	^ nil
]

{ #category : #accessing }
TMbndAbstractType >> usedTraits [
	^ #()
]

{ #category : #sizes }
TMbndAbstractType >> valueAlignment [
	^ self instanceAlignment
]

{ #category : #sizes }
TMbndAbstractType >> valueSize [
	^ self instanceSize
]

{ #category : #'type composition' }
TMbndAbstractType >> volatile [
	<compileTime>
	^ self withDecoration: #volatile
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withAllSubtypes [
	| result |
	result := OrderedCollection new.
	self withAllSubtypesDo: [ :st | result add: st ].
	^ result
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withAllSubtypesDo: aBlock [
	aBlock value: self.
	self allSubtypesDo: aBlock
]

{ #category : #accessing }
TMbndAbstractType >> withAllTraitUsersDo: aBlock [
	aBlock value: self.
	self allTraitUsersDo: aBlock
]

{ #category : #'type composition' }
TMbndAbstractType >> withDecoration: decoration [
	<compileTime>
	^ self compilationTarget type: self withDecorations: {decoration}
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withSubtypesDo: aBlock [
	aBlock value: self.
	self subtypesDo: aBlock
]

{ #category : #'type composition' }
TMbndAbstractType >> withoutDecorations [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> withoutReferences [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> withoutTopDecorations [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> | otherType [
	^ self compilationTarget variantUnionTypeWithComponents: { self . otherType }
]
