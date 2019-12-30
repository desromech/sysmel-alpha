"
I provide the fundamental protocol for the MoebiusBand type system. I am the core of this Meta Object Protocol that expands the Smalltalk MOP with macros, and primitive types.
"
Trait {
	#name : #TMbndAbstractType,
	#instVars : [
		'extraMetaBuilderFactories'
	],
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'type composition' }
TMbndAbstractType >> , nextType [
	<compileTime>
	^ self compilationTarget tuple: { self . nextType }
]

{ #category : #'type composition' }
TMbndAbstractType >> ,, nextType [
	<compileTime>
	^ self compilationTarget tuple: { self . nextType }
]

{ #category : #'type composition' }
TMbndAbstractType >> -- nextType [
	<compileTime>
	^ self compilationTarget tuple: { self . nextType }
]

{ #category : #'type composition' }
TMbndAbstractType >> --> valueType [
	<compileTime>
	^ self compilationTarget associationKey: self value: valueType
]

{ #category : #'type composition' }
TMbndAbstractType >> => returnType [
	<compileTime>
	^ self compilationTarget functionTypeWithArguments: { self } returnType: returnType
]

{ #category : #converting }
TMbndAbstractType >> addConversionRule: conversionRule [
	self
		addExplicitConversionRule: conversionRule;
		addImplicitConversionRule: conversionRule
]

{ #category : #adding }
TMbndAbstractType >> addConversionRulesToPointerType: referenceType [
]

{ #category : #adding }
TMbndAbstractType >> addConversionRulesToReferenceType: referenceType [
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
		addConversionRule: MbndIdentityTypeConversionRule new;
		addConversionRule: MbndToCompilerObjectTypeConversionRule new;
		addConversionRule: MbndToTypeConceptConversionRule new;
		addExplicitConversionRule: MbndFromCompilerObjectTypeConversionRule new.
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

{ #category : #sizes }
TMbndAbstractType >> alignedInstanceSize [
	"By default, most of the type sizes are aligned. One notable exception is primitive vector3.".
	^ self instanceSize
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
	self allSubtypesDo: aBlock
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> analyzeBasicInitializationNode: node with: analyzer [
	"By default do nothing. This is supposed to be used for initializing vtables of aggregate types."
	^ node receiver
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

{ #category : #converting }
TMbndAbstractType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	self error: 'Cannot perform reinterpret cast from {1} to {2}.' format: { self asString . targetType asString } at: node
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	(self isMetaType or: [ self isMetaTypeType ]) ifTrue: [ 
		| selector receiverValue staticMethod arguments result |
		(node receiver isLiteralValueNode and:
		[ node selector isLiteralSymbolValueNode ]) ifTrue: [
			selector := node selector value.
			receiverValue := node receiver value.
		
			"Check for an overloaded method."
			staticMethod := receiverValue lookupOverloadedStaticSelector: node selector value.
			staticMethod ifNotNil: [
				^ staticMethod analyzeExpandedMessageSendNode: node with: analyzer
			].
		
			(receiverValue class lookupSelector: selector) ifNotNil: [ :method |
				(method hasPragmaNamed: #compileTime) ifTrue: [
					arguments := node arguments collect: [ :arg | (analyzer evaluateCompileTimeExpression: arg) unwrapMbndValue ].
					result := receiverValue perform: selector withArguments: arguments.
				^ analyzer visitNode: (result asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
				]
			]
		].
	].

	self supertype ifNotNil: [:st |
		^ st analyzeUnboundExpandedMessageSendNode: node with: analyzer
	].

	^ node receiver type analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	(self isMetaType or: [ self isMetaTypeType ]) ifTrue: [ 
		| selector receiverValue staticMacro |
		(node receiver isLiteralValueNode and:
		[ node selector isLiteralSymbolValueNode ]) ifTrue: [
			selector := node selector value.
			receiverValue := node receiver value.
			(receiverValue lookupPublicMetaBuilderFactoryNamed: selector withAnalyzer: analyzer) ifNotNil: [ :factory |
				^ factory analyzeReferenceNode: node ownerProgramEntity: receiverValue with: analyzer
			].
	
			"Check for an overloaded method."
			staticMacro := receiverValue lookupStaticMacroSelector: node selector value.
			staticMacro ifNotNil: [
				^ staticMacro expandMessageNode: node with: analyzer
			].
		].
	].

	self supertype ifNotNil: [:st |
		^ st analyzeUnboundUnexpandedMessageSendNode: node with: analyzer
	].

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

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer [
	self supertype ifNotNil: [:st |
		^ st analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer
	].

	self error: 'Cannot send unknown message {1} to value of type {2}.' format: {node selector printValueString. node receiver type fullName} at: node
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> arithmeticCoercionWith: rightType [
	^ self compilationTarget computeArithmeticCoercionTypeFor: self with: rightType
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> arithmeticCoercionWith: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [
	^ self compilationTarget computeArithmeticCoercionTypeFor: self with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope
]

{ #category : #'type composition' }
TMbndAbstractType >> array [
	<compileTime>
	^ self array: 0
]

{ #category : #'type composition' }
TMbndAbstractType >> array: elementCount [
	<compileTime>
	^ self compilationTarget arrayOf: self elements: elementCount
]

{ #category : #converting }
TMbndAbstractType >> asCVariadicType [
	^ self asCVariadicTypeRequiredAt: MbndSourcePosition new
]

{ #category : #converting }
TMbndAbstractType >> asCVariadicTypeRequiredAt: aPosition [
	self error: 'Cannot pass value of type {1} as a C variadic argument.' format: { self fullName } at: aPosition
]

{ #category : #converting }
TMbndAbstractType >> asConcreteTypeForAnalysisOfFunction: aFunction [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> asConcreteTypeForAnalysisOfFunctionType: aFunction [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> asCopyConstructorParameter [
	^ self const ref
]

{ #category : #converting }
TMbndAbstractType >> asFieldTypeFor: owner [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> asImmutableValueType [
	^ self
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

{ #category : #converting }
TMbndAbstractType >> asMovementConstructorParameter [
	^ self const tempRef
]

{ #category : #converting }
TMbndAbstractType >> asMutableValueType [
	^ self ref
]

{ #category : #converting }
TMbndAbstractType >> asPointerType [
	self error: 'Cannot convert type {1} into a pointer type version.' format: { self asString }
]

{ #category : #converting }
TMbndAbstractType >> asReceiverType [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> asReferenceType [
	self error: 'Cannot convert type {1} into a reference type version.' format: { self asString }
]

{ #category : #converting }
TMbndAbstractType >> asResultTypeWithReceiver: receiverType withArguments: argumentTypes [
	^ self
]

{ #category : #converting }
TMbndAbstractType >> asSuperArgumentType [
	^ self supertype ifNil: [ self compilationTarget voidType ]
]

{ #category : #converting }
TMbndAbstractType >> asTemporaryReferenceType [
	self error: 'Cannot convert type {1} into a reference type version.' format: { self asString }
]

{ #category : #converting }
TMbndAbstractType >> asUndecoratedClassType [
	^ self withoutTopDecorations
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> bindingSetPointer [
	<compileTime>
	^ self pointerFor: #bindingSet
]

{ #category : #converting }
TMbndAbstractType >> buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes [
	| previousTypeAndRule previousType rule previousRule |
	previousTypeAndRule := visitedTypes at: targetType ifAbsent: [nil].
	previousTypeAndRule ifNil: [ ^ nil ].
	
	previousType := previousTypeAndRule first.
	rule := previousTypeAndRule second.
	previousType == targetType ifTrue: [ ^ rule ].
	previousType ifNil: [ ^ rule ].
	
	previousRule := self buildTypeConversionChainUntil: previousType fromVisitedTypes: visitedTypes.
	previousRule ifNil: [ ^ rule ].
	
	^ previousRule intermediateConversion: previousType chainedWith: rule
]

{ #category : #testing }
TMbndAbstractType >> canValueBeCreatedForNode: node [
	"This allows the opportunity of creating values of types with a specific kind of node, and avoiding of type conversion machinery. This is useful to convert tuple creation nodes into arrays without creating an intermediate tuple value in the process."
	^ false
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> conditionalResultCoercionTypeWith: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [
	^ self compilationTarget computeConditionalResultCoercionTypeFor: self with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope
]

{ #category : #'type composition' }
TMbndAbstractType >> const [
	<compileTime>
	^ self withDecoration: #const
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> createExtraMetaBuilderFactories [
	^ Dictionary newFromPairs: self getExtraMetaBuilderFactoryList
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> createMetaTypeBasicInstance [
	^ MbndSimpleMetaType basicNew
]

{ #category : #testing }
TMbndAbstractType >> createValueForNode: node withAnalyzer: analyzer [
	self error: 'Should not be here.'
]

{ #category : #accessing }
TMbndAbstractType >> decorations [
	^ #()
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> defaultArgumentType [
	^ nil
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> defaultReturnType [
	^ nil
]

{ #category : #'default values' }
TMbndAbstractType >> defaultValue [
	^ self defaultValueAt: MbndSourcePosition empty

]

{ #category : #'default values' }
TMbndAbstractType >> defaultValueASTNodeAt: aPosition [
	^ ((self defaultValueAt: aPosition) asLiteralValueNode)
		position: aPosition;
		yourself

]

{ #category : #'default values' }
TMbndAbstractType >> defaultValueAt: aPosition [
	self error: 'Cannot obtain value of type {1}. ' format: { self asString } at: aPosition

]

{ #category : #'meta builder factories' }
TMbndAbstractType >> extraMetaBuilderFactories [
	^ extraMetaBuilderFactories ifNil: [ extraMetaBuilderFactories := self createExtraMetaBuilderFactories ]
]

{ #category : #converting }
TMbndAbstractType >> findConversionRuleInto: targetType node: node rulesExtractor: rulesExtractor [
	| visitedTypes pendingTypes currentTypeFromToCheck currentType incomingTypeAndRule implicitUpcastRule |
	visitedTypes := IdentityDictionary new.
	pendingTypes := LinkedList new.
	implicitUpcastRule := MbndImplicitUpcastTypeConversionRule new.
	
	pendingTypes add: { self . nil }.
	
	[ pendingTypes isEmpty ] whileFalse: [ 
		currentTypeFromToCheck := pendingTypes first.
		pendingTypes removeFirst.
		
		currentType := currentTypeFromToCheck first.
		incomingTypeAndRule := currentTypeFromToCheck second.

		(currentType == targetType and: [ incomingTypeAndRule isNotNil ]) ifTrue: [
			visitedTypes at: currentType ifAbsentPut: incomingTypeAndRule.
			^ self buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes
		].
		
		(visitedTypes includesKey: currentType) ifFalse: [ 
			"Ignore the types that were already visited."
			visitedTypes at: currentType put: incomingTypeAndRule.
		
			(rulesExtractor value: currentType) do: [ :rule |
				(rule canBeUsedToConvertNode: node from: currentType into: targetType) ifTrue: [
					visitedTypes at: targetType put: {currentType . rule}.
					^ self buildTypeConversionChainUntil: targetType fromVisitedTypes: visitedTypes
				].
			
				rule isTypeKindConversion ifTrue: [
					rule targetTypeKind withAllTraitUsersDo: [ :nextType |
						(rule canBeUsedToConvertNode: node from: currentType into: nextType) ifTrue: [
							(visitedTypes includesKey: nextType) ifFalse: [
								pendingTypes addLast: { nextType . { currentType . rule } }.
							]
						]
					]
				]
			].
		
			currentType usedTraits do: [ :trait |
				(visitedTypes includesKey: trait) ifFalse: [
					(implicitUpcastRule canBeUsedToConvertNode: node from: currentType into: trait) ifTrue: [ 
						pendingTypes addLast: { trait . { currentType . implicitUpcastRule } }.
					]
				]
			]
		]
	].

	^ nil
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> fullName [
	self explicitRequirement
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> getExtraMetaBuilderFactoryList [
	^ { 
		"#method . MbndMethodMetaBuilder metaBuilderFactory."
	}
]

{ #category : #testing }
TMbndAbstractType >> hasDynamicMessageLookup [
	^ false
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> hasImmediateSupertype: aType [
	^ self supertype == aType
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialBasicInitialization [
	^ self hasTrivialInstanceBasicInitialization
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialFinalization [
	^ self hasTrivialInstanceFinalization
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInitialization [
	^ self hasTrivialInstanceInitialization
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInitializationFromCopy [
	^ self hasTrivialInstanceInitializationFromCopy
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInitializationMovingFrom [
	^ self hasTrivialInstanceInitializationMovingFrom
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInstanceBasicInitialization [
	^ true
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInstanceFinalization [
	^ true
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInstanceInitialization [
	^ true
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInstanceInitializationFromCopy [
	^ true
]

{ #category : #testing }
TMbndAbstractType >> hasTrivialInstanceInitializationMovingFrom [
	^ true
]

{ #category : #adding }
TMbndAbstractType >> implicitFunctionReceiverType [
	^ self asReceiverType
]

{ #category : #adding }
TMbndAbstractType >> implicitMethodReceiverType [
	^ self asReceiverType
]

{ #category : #'type inference' }
TMbndAbstractType >> inferValueTypeForNode: initialValueNode inScope: scope [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> inputChannel [
	<compileTime>
	^ self compilationTarget inputChannelFor: self
]

{ #category : #sizes }
TMbndAbstractType >> instanceAlignment [
	^ self explicitRequirement
]

{ #category : #sizes }
TMbndAbstractType >> instanceSize [
	<compileTime>
	^ self explicitRequirement
]

{ #category : #'testing methods' }
TMbndAbstractType >> isASTNodeType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isAbstractClassType [
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
TMbndAbstractType >> isAssociationType [
	^ false
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> isBestConcreteTypeForLiteralValueNode: literalValueNode [
	^ self == (literalValueNode type bestConcreteTypeForLiteralValueNode: literalValueNode inScope: MbndLexicalScope new)
]

{ #category : #'testing methods' }
TMbndAbstractType >> isBlockClosureType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isClassType [
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

{ #category : #testing }
TMbndAbstractType >> isDependentType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isDerivedType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isDictionaryType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isEnumType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isFunctionTemplateType [
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
TMbndAbstractType >> isGCClassType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isGCClassVariableDataArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isIOChannelType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isInputChannelType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralAssociationType [
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
TMbndAbstractType >> isLiteralByteArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralCharacterType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralDictionaryType [
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
TMbndAbstractType >> isLiteralScalarType [
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
TMbndAbstractType >> isMessageTemplateType [
	^ false
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
TMbndAbstractType >> isMetaTypeType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isMethodTemplateType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isNamespaceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isOpaqueHandleType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isOpaqueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isOutputChannelType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPointerLikeValueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPointerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPossibleToLoadReferences [
	^ true
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveBooleanType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveCharacterCodeType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveFloatType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveIntegerType [
	<compileTime>
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveMatrixOrVectorType [
	^ self isPrimitiveMatrixType or: [ self isPrimitiveVectorType ]
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveMatrixType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveNumberType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveScalarType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveVectorType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isReferenceLikeValueType [
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
TMbndAbstractType >> isSamplerType [
	^ false
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> isStandardConcreteTypeForLiteralValueNode: literalValueNode [
	^ self == (literalValueNode type standardConcreteTypeForLiteralValueNode: literalValueNode inScope: MbndLexicalScope new)
]

{ #category : #'testing methods' }
TMbndAbstractType >> isStructureType [
	^ false
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> isSubtypeOf: aType [
	| currentType |
	currentType := self.
	[ currentType ] whileNotNil: [ 
		(currentType hasImmediateSupertype: aType) ifTrue: [ ^ true ].
		currentType := currentType supertype.
	].

	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTemplateType [
	^ false
]

{ #category : #testing }
TMbndAbstractType >> isTemporaryReferenceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTextureType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTrait [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTupleType [
	^ false
]

{ #category : #testing }
TMbndAbstractType >> isTypeConcept [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isTypeTemplateType [
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
	<compileTime>
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

{ #category : #'as yet unclassified' }
TMbndAbstractType >> lookupOverloadedStaticSelector: selector [
	^ nil
]

{ #category : #'meta builder factories' }
TMbndAbstractType >> lookupPublicMetaBuilderFactoryNamed: name withAnalyzer: analyzer [
	^ self publicMetaBuilderFactories at: name ifAbsent: [ nil ]
]

{ #category : #methods }
TMbndAbstractType >> lookupSelector: aSelector [
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #symbols }
TMbndAbstractType >> lookupSpecialSymbol: aSymbol [
	aSymbol == #SelfType ifTrue: [ ^ self ].
	aSymbol == #meta ifTrue: [ ^ self meta ].
	self extraMetaBuilderFactories at: aSymbol ifPresent: [ :binding | ^ binding ].
	^ nil
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> lookupStaticMacroSelector: selector [
	^ nil
]

{ #category : #symbols }
TMbndAbstractType >> lookupSymbol: aSymbol [
	(self lookupSpecialSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	^ self supertype ifNotNil: [ :st | st lookupSymbol: aSymbol ]
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> markAsMetaTypeType [
	self error: 'Cannot use type {1} as a meta-type type.' format: {self asString}
]

{ #category : #'as yet unclassified' }
TMbndAbstractType >> mbndLiteralTypeWithTarget: compilationTarget [
	^ self type
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> meta [
	<compileTime>
	^ self type
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
TMbndAbstractType >> outputChannel [
	<compileTime>
	^ self compilationTarget outputChannelFor: self
]

{ #category : #'type composition' }
TMbndAbstractType >> pointer [
	<compileTime>
	^ self pointerFor: MbndPointerLikeType genericAddressSpace
]

{ #category : #'type composition' }
TMbndAbstractType >> pointerFor: addressSpace [
	<compileTime>
	^ self compilationTarget pointerFor: addressSpace to: self
]

{ #category : #accessing }
TMbndAbstractType >> publicMetaBuilderFactories [
	^ publicMetaBuilderFactories ifNil: [ publicMetaBuilderFactories := self createPublicMetaBuilderFactories ]
]

{ #category : #'type composition' }
TMbndAbstractType >> pushConstantPointer [
	<compileTime>
	^ self pointerFor: #pushConstant
]

{ #category : #'type composition' }
TMbndAbstractType >> ref [
	<compileTime>
	^ self refFor: MbndPointerLikeType genericAddressSpace
]

{ #category : #'type composition' }
TMbndAbstractType >> refFor: addressSpace [
	<compileTime>
	^ self compilationTarget referenceFor: addressSpace to: self
]

{ #category : #accessing }
TMbndAbstractType >> slotLayout [
	^ nil
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self
]

{ #category : #'type composition' }
TMbndAbstractType >> storageBufferPointer [
	<compileTime>
	^ self pointerFor: #storageBuffer
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

{ #category : #'type composition' }
TMbndAbstractType >> tempRef [
	<compileTime>
	^ self tempRefFor: MbndPointerLikeType genericAddressSpace
]

{ #category : #'type composition' }
TMbndAbstractType >> tempRefFor: addressSpace [
	<compileTime>
	^ self compilationTarget temporaryReferenceFor: addressSpace to: self
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> type [
	<compileTime>
	"I answer a meta type."
	^ nil
]

{ #category : #'type composition' }
TMbndAbstractType >> uniformBufferPointer [
	<compileTime>
	^ self pointerFor: #uniformBuffer
]

{ #category : #accessing }
TMbndAbstractType >> usedTraits [
	self supertype ifNotNil: [ :st | ^ { st } ].
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
	^ self withDecorations: { decoration }
]

{ #category : #'type composition' }
TMbndAbstractType >> withDecorations: decorations [
	<compileTime>
	^ self compilationTarget type: self withDecorations: decorations
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
	<compileTime>
	^ self compilationTarget variantUnionTypeWithComponents: { self . otherType }
]
