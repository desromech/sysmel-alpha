Class {
	#name : #MbndAggregateTypeWithFields,
	#superclass : #MbndAggregateType,
	#instVars : [
		'fields',
		'slotLayout',
		'basicInitializeMethod',
		'initializeMethod',
		'hasTrivialInstanceInitialization',
		'hasTrivialInstanceFinalization',
		'hasTrivialInstanceInitializationFromCopy',
		'hasTrivialInstanceInitializationMovingFrom',
		'finalizeMethod',
		'initializeFromCopyMethod',
		'initializeMovingFromMethod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAggregateTypeWithFields class >> typeName [
	^ #_AggregateTypeWithFields
]

{ #category : #adding }
MbndAggregateTypeWithFields >> addField: aField [
	self addChild: aField.
	
	aField name isMbndAnonymousSymbol ifFalse: [ 
		self setLocalSymbol: aField name value: aField.
	].

	self fields add: aField.
]

{ #category : #initialization }
MbndAggregateTypeWithFields >> addInstanceMacros [
	self class == MbndAggregateTypeWithFields ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelector: #__private do: [ :node :builder :analyzer|
			| analyzedReceiver receiverAggregateType resultNode |
			analyzedReceiver := analyzer analyzeNodeIfNeeded: node receiver.
			receiverAggregateType := analyzedReceiver type asUndecoratedClassType.
			self assert: receiverAggregateType isAggregateType.
			resultNode := builder delegateToMetaBuilderClass: MbndPrivateAccessingMetaBuilder withAnalyzer: analyzer at: node.
			resultNode instance
				aggregateNode: analyzedReceiver;
				aggregateType: receiverAggregateType.
			resultNode
		]
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> basicInitializeMethod [
	basicInitializeMethod ifNil: [ self createBasicInitializeMethod ].
	^ basicInitializeMethod
]

{ #category : #layout }
MbndAggregateTypeWithFields >> buildSlotLayout [
	| builder |
	builder := self slotLayoutBuilderClass new aggregate: self.
	self buildSlotLayoutWith: builder.
	slotLayout := builder finish.
]

{ #category : #layout }
MbndAggregateTypeWithFields >> buildSlotLayoutWith: builder [
	self evaluateAllPendingDefinitionFragments.
	builder recordTypeStartLocation: self.
	self buildSuperTypesSlotLayoutWith: builder.
	self fields do: [ :field |
		builder addField: field
	].
	builder recordTypeEndLocation: self.

]

{ #category : #layout }
MbndAggregateTypeWithFields >> buildSuperTypesSlotLayoutWith: builder [
	self nonTraitSuperType ifNotNil: [ :st |
		st
			buildSlotLayoutWith: builder
	]

]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> createBasicInitializeMethod [
	| asReceiverType |
	asReceiverType := self asReceiverType.
	self assert: self compilationEnvironment currentModule isNotNil.
	basicInitializeMethod := MbndAggregateBasicInitializeMethod new
		name: #basicInitialize;
		receiverType: asReceiverType;
		module: self compilationEnvironment currentModule;
		type: (self compilationTarget functionTypeWithArguments: {asReceiverType} returnType: self compilationTarget voidType);
		boundType: (self compilationTarget functionTypeWithArguments: #() returnType: self compilationTarget voidType).
	self
		addChild: basicInitializeMethod;
		addOverloadedMethod: basicInitializeMethod
]

{ #category : #'default values' }
MbndAggregateTypeWithFields >> defaultAggregateValueAt: aPosition [
	| valueSlots |
	self isDefined ifFalse: [ 
		self error: 'Cannot produce a value for incomplete type {1}.' format: { self asString } at: aPosition
	].

	valueSlots := self slotLayout slots collect: [ :slot | (slot defaultValueAt: aPosition) unwrapMbndValue].
	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: valueSlots;
		yourself
]

{ #category : #'default values' }
MbndAggregateTypeWithFields >> defaultValueAt: position [
	^ self defaultAggregateValueAt: position
]

{ #category : #serialization }
MbndAggregateTypeWithFields >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ (super encodeLazyFieldsForMessagePackWith: graphEncoder) , {
		#fields . fields encodeGraphForMessagePackWith: graphEncoder.
		#slotLayout . slotLayout encodeGraphForMessagePackWith: graphEncoder.
		#hasTrivialInstanceInitialization. hasTrivialInstanceInitialization.
		#hasTrivialInstanceFinalization. hasTrivialInstanceFinalization.
		#hasTrivialInstanceInitializationFromCopy. hasTrivialInstanceInitializationFromCopy.
		#hasTrivialInstanceInitializationMovingFrom. hasTrivialInstanceInitializationMovingFrom.
		#basicInitializeMethod. basicInitializeMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeMethod. initializeMethod encodeGraphForMessagePackWith: graphEncoder.
		#finalizeMethod. finalizeMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeFromCopyMethod. initializeFromCopyMethod encodeGraphForMessagePackWith: graphEncoder.
		#initializeMovingFromMethod. initializeMovingFromMethod encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #'semantic analysis' }
MbndAggregateTypeWithFields >> ensureGeneratedMethodsExist [
	self hasTrivialInstanceBasicInitialization ifFalse: [ self basicInitializeMethod ].
	self hasTrivialInstanceInitialization ifFalse: [ self initializeMethod ].
	self hasTrivialInstanceInitializationCopyingFrom ifFalse: [ self initializeCopyingFromMethod ].
	self hasTrivialInstanceInitializationMovingFrom ifFalse: [ self initializeMovingFromMethod ].
	self hasTrivialInstanceFinalization ifFalse: [ self finalizeMethod ].

]

{ #category : #'semantic analysis' }
MbndAggregateTypeWithFields >> ensureSemanticAnalysis [
	self evaluateAllPendingDefinitionFragments.
	self isDefined ifTrue: [ 
		"self ensureSlotLayoutIsComputed."
		self slotLayout.
		self ensureGeneratedMethodsExist.
	].
	super ensureSemanticAnalysis.

]

{ #category : #layout }
MbndAggregateTypeWithFields >> ensureSlotLayoutIsComputed [
	(self hasFlag: #computingSlotLayout) ifTrue: [ 
		self error: 'Type with circular slot layout.'
	].
	self
		addFlag: #computingSlotLayout;
		buildSlotLayout;
		removeFlag: #computingSlotLayout.

]

{ #category : #accessing }
MbndAggregateTypeWithFields >> fields [
	self evaluateAllPendingDefinitionFragments.
	^ fields ifNil: [ fields := OrderedCollection new ]
]

{ #category : #converting }
MbndAggregateTypeWithFields >> fillProgramEntityInfoInstance: typeInfoInstance [
	super fillProgramEntityInfoInstance: typeInfoInstance.
	self superclass ifNotNil: [:sc |
		typeInfoInstance
			setField: #superclass value: sc.
	].
]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> finalizeMethod [
	^ finalizeMethod ifNil: [ finalizeMethod := self getOrCreateOptionallyGeneratedMethod: #finalize ofKind: MbndAggregateFinalizeMethod argumentTypes: #() returnType: self compilationTarget voidType]
]

{ #category : #'as yet unclassified' }
MbndAggregateTypeWithFields >> findFirstFieldNamed: fieldName [
	^ self slotLayout findFirstFieldNamed: fieldName
	
]

{ #category : #'meta builder factories' }
MbndAggregateTypeWithFields >> getExtraMetaBuilderFactoryList [
	^ super getExtraMetaBuilderFactoryList ,  { 
		#field . MbndFieldMetaBuilder metaBuilderFactory.
	}
]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> getOrCreateOptionallyGeneratedMethod: selector ofKind: generatedMethodClass argumentTypes: argumentTypes returnType: returnType [
	| method parentVersion asReceiverType |
	self overloadedMethodDict at: selector ifPresent: [ :existent |
		self flag: 'TODO: Check the existent method argument types.'.
		^ existent
	].

	asReceiverType := self asReceiverType.
	self assert: self compilationEnvironment currentModule isNotNil.
	method := generatedMethodClass new
		module: self compilationEnvironment currentModule;
		name: selector;
		receiverType: asReceiverType;
		type: (self compilationTarget functionTypeWithArguments: {asReceiverType} , argumentTypes returnType: returnType);
		boundType: (self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType).

	self supertype isTrait not ifTrue: [
		parentVersion := self supertype lookupOverloadedSelector: selector withBoundType: method boundType.
		(parentVersion isNotNil and: [ parentVersion hasVirtualTableEntry ]) ifTrue: [
			method addFlag: #override
		].
	].

	self
		addChild: method;
		addOverloadedMethod: method.
	^ method
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasNonCompilerGeneratedMethod: selector [
	| method |
	method := self overloadedMethodDict at: selector ifAbsent: [ ^ false ].
	^ method isCompilerGeneratedMethod not
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasTrivialInstanceBasicInitialization [
	self isTrait ifTrue: [ ^ super hasTrivialInstanceBasicInitialization ].
	self isDefined ifFalse: [ ^ true ].
	
	^ self slotLayout hasTrivialBasicInitialization
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasTrivialInstanceFinalization [
	self isTrait ifTrue: [ ^ super hasTrivialInstanceFinalization ].
	self isDefined ifFalse: [ ^ true ].
	
	^ hasTrivialInstanceFinalization ifNil: [
		hasTrivialInstanceFinalization := self supertype hasTrivialInstanceFinalization
		and: [self slotLayout hasTrivialFinalization
		and: [ (self hasNonCompilerGeneratedMethod: #finalize) not ] ]
	]
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasTrivialInstanceInitialization [
	self isTrait ifTrue: [ ^ super hasTrivialInstanceInitialization ].
	self isDefined ifFalse: [ ^ true ].

	^ hasTrivialInstanceInitialization ifNil: [
		hasTrivialInstanceInitialization := self supertype hasTrivialInstanceInitialization
		and: [self slotLayout hasTrivialInitialization
		and: [ (self hasNonCompilerGeneratedMethod: #initialize) not ] ]
	]
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasTrivialInstanceInitializationCopyingFrom [
	self isTrait ifTrue: [ ^ super hasTrivialInstanceInitializationCopyingFrom ].
	self isDefined ifFalse: [ ^ true ].
	
	^ hasTrivialInstanceInitializationFromCopy ifNil: [
		hasTrivialInstanceInitializationFromCopy := self supertype hasTrivialInstanceInitializationCopyingFrom
		and: [self slotLayout hasTrivialInitializationCopyingFrom
		and: [ (self hasNonCompilerGeneratedMethod: #initializeCopyingFrom:) not ] ]
	]
]

{ #category : #testing }
MbndAggregateTypeWithFields >> hasTrivialInstanceInitializationMovingFrom [
	self isTrait ifTrue: [ ^ super hasTrivialInstanceInitializationMovingFrom ].
	self isDefined ifFalse: [ ^ true ].
	
	^ hasTrivialInstanceInitializationMovingFrom ifNil: [
		hasTrivialInstanceInitializationMovingFrom := self supertype hasTrivialInstanceInitializationMovingFrom
		and: [self slotLayout hasTrivialInitializationMovingFrom
		and: [ (self hasNonCompilerGeneratedMethod: #initializeMovingFrom:) not ] ]
	]
]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> initializeCopyingFromMethod [
	^ initializeFromCopyMethod ifNil: [ initializeFromCopyMethod := self getOrCreateOptionallyGeneratedMethod: #initializeCopyingFrom: ofKind: MbndAggregateInitializeFromCopyMethod argumentTypes: {self asCopyConstructorParameter} returnType: self compilationTarget voidType ]
]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> initializeMethod [
	^ initializeMethod ifNil: [ initializeMethod := self getOrCreateOptionallyGeneratedMethod: #initialize ofKind: MbndAggregateInitializeMethod argumentTypes: #() returnType: (self isGCClassType 		ifTrue: [self asReceiverType]
		ifFalse: [self compilationTarget voidType]) ]
]

{ #category : #'initialize-destroy' }
MbndAggregateTypeWithFields >> initializeMovingFromMethod [
	^ initializeMovingFromMethod ifNil: [ initializeMovingFromMethod := self getOrCreateOptionallyGeneratedMethod: #initializeMovingFrom: ofKind: MbndAggregateInitializeMovingFromMethod argumentTypes: {self asMovementConstructorParameter} returnType: self compilationTarget voidType ]
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> instanceAlignment [
	<compileTime>
	^ self instanceDataAlignment
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> instanceDataAlignment [
	<compileTime>
	self isDefined ifFalse: [ ^ 1 ].
	^ self slotLayout instanceAlignment
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> instanceDataSize [
	<compileTime>
	self isDefined ifFalse: [ ^ 0 ].
	^ self slotLayout instanceSize
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> instanceSize [
	<compileTime>
	^ self instanceDataSize
]

{ #category : #testing }
MbndAggregateTypeWithFields >> isCopyable [
	<compileTime>
	^ (self hasFlag: #nonCopyable) not
]

{ #category : #testing }
MbndAggregateTypeWithFields >> isModuleSpecificType [
	^ true
]

{ #category : #testing }
MbndAggregateTypeWithFields >> isMoveable [
	<compileTime>
	^ (self hasFlag: #nonMoveable) not
]

{ #category : #testing }
MbndAggregateTypeWithFields >> isNonMoveable [
	<compileTime>
	^ self hasFlag: #nonMoveable
]

{ #category : #'default values' }
MbndAggregateTypeWithFields >> makeInstance [
	^ self defaultValueAt: nil
]

{ #category : #'as yet unclassified' }
MbndAggregateTypeWithFields >> makeNonCopyable [
	<compileTime>
	^ self addFlag: #nonCopyable
]

{ #category : #'as yet unclassified' }
MbndAggregateTypeWithFields >> makeNonMoveable [
	<compileTime>
	^ self addFlag: #nonMoveable
]

{ #category : #serialization }
MbndAggregateTypeWithFields >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.
	
	fields := encodedFields at: #fields.
	slotLayout := encodedFields at: #slotLayout.
	hasTrivialInstanceInitialization := encodedFields at: #hasTrivialInstanceInitialization.
	hasTrivialInstanceFinalization := encodedFields at: #hasTrivialInstanceFinalization.
	hasTrivialInstanceInitializationFromCopy := encodedFields at: #hasTrivialInstanceInitializationFromCopy.
	hasTrivialInstanceInitializationMovingFrom := encodedFields at: #hasTrivialInstanceInitializationMovingFrom.
	basicInitializeMethod := encodedFields at: #basicInitializeMethod.
	initializeMethod := encodedFields at: #initializeMethod.
	finalizeMethod := encodedFields at: #finalizeMethod.
	initializeFromCopyMethod := encodedFields at: #initializeFromCopyMethod.
	initializeMovingFromMethod := encodedFields at: #initializeMovingFromMethod.
]

{ #category : #layout }
MbndAggregateTypeWithFields >> nonTraitSuperType [
	^ (self compilationTarget getBasicTypeNamed: self class typeName) == supertype
		ifTrue: [ nil ] ifFalse: [ supertype ]
]

{ #category : #accessing }
MbndAggregateTypeWithFields >> slotLayout [
	slotLayout ifNil: [
		self isDefined ifFalse: [ 
			self error: 'Cannot instantiate or inherit from opaque type.'
		].
		self ensureSlotLayoutIsComputed
	].
	^ slotLayout
]

{ #category : #layout }
MbndAggregateTypeWithFields >> slotLayoutBuilderClass [
	^ MbndAggregateSlotLayoutBuilder
]

{ #category : #converting }
MbndAggregateTypeWithFields >> superclass [
	^ supertype isTrait
		ifTrue: [ nil ]
		ifFalse: [ self supertype ].
]
