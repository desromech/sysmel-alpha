Class {
	#name : #SYMLStructure,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'fields',
		'hasConcretedSSAType',
		'analyzed',
		'structureSSAType',
		'slotsLayout',
		'hasInitialization',
		'hasFinalization',
		'isPODType',
		'instanceDataSize',
		'instanceDataAlignment',
		'hasComputeInstanceSizes',
		'hasBasicInitialization'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #adding }
SYMLStructure >> addFieldVariable: field at: aPosition [
	field hasDontCareName ifFalse: [ 
		symbols at: field name ifPresent: [ :existent |
			self error: 'Field {1} overrides an existent field.' format: { field name } at: aPosition
		] ifAbsentPut: [ field ].
	].

	fields add: field
]

{ #category : #'semantic analysis' }
SYMLStructure >> allFields [
	^ fields
]

{ #category : #'code generation' }
SYMLStructure >> basicInitializeSSAVariable: ssaVariable with: builder [
	| initializer |
	self hasNonTrivialBasicInitialization ifFalse: [
		self allFields do: [ :field |
			field basicInitializeSSAVariable: ssaVariable with: builder
		].
		^ self
	].

	initializer := self lookupSelector: #basicInitialize.
	initializer generateSimpleSSACallWithArguments: {ssaVariable} with: builder.
]

{ #category : #'code generation' }
SYMLStructure >> buildConcreteStructureSSAType [
	self module ssaModule addStructure: self structureSSAType.
	self structureSSAType
		names: (slotsLayout collect: #name);
		types: (slotsLayout collect: #concreteSSAType).


]

{ #category : #'semantic analysis' }
SYMLStructure >> buildLayout [
	| builder |
	slotsLayout ifNotNil: [ ^ self ].
	
	builder := SYMLStructureSlotsLayoutBuilder new structure: self.
	self allFields do: [ :field | field addToStructureLayoutBuilder: builder ].
	builder flush.
	slotsLayout := builder slots
]

{ #category : #'code generation' }
SYMLStructure >> buildSSAType [
	^ self structureSSAType
]

{ #category : #'code generation' }
SYMLStructure >> buildStructureSSAType [
	^ (self isPacked ifTrue: [SLVMPackedStructureType new ] ifFalse: [SLVMStructureType new])
		name: self mangledName; kind: SLVMStructureType genericKind.
]

{ #category : #'initialization finalization' }
SYMLStructure >> checkNonTrivialBasicInitialization [
	self supertype ifNotNil: [ :st | st hasNonTrivialGCBasicInitialization ifTrue: [^ true]].
	super checkNonTrivialBasicInitialization ifTrue: [ ^ true ].
	fields do: [ :field |
		field hasNonTrivialGCBasicInitialization ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : #'initialization finalization' }
SYMLStructure >> checkNonTrivialFinalization [
	self supertype ifNotNil: [ :st | st hasNonTrivialGCFinalization ifTrue: [^ true]].
	super checkNonTrivialFinalization ifTrue: [ ^ true ].
	fields do: [ :field |
		field type checkNonTrivialFinalization ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : #'initialization finalization' }
SYMLStructure >> checkNonTrivialInitialization [
	self supertype ifNotNil: [ :st | st hasNonTrivialGCInitialization ifTrue: [^ true]].
	super checkNonTrivialInitialization ifTrue: [ ^ true ].
	fields do: [ :field |
		field hasNonTrivialGCInitialization ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : #testing }
SYMLStructure >> checkPODType [
	self hasNonTrivialInitialization ifTrue: [ ^ false ].
	self hasNonTrivialFinalization ifTrue: [ ^ false ].
	self allFields do: [ :field |
		field type isPODType ifFalse: [ ^ false ].
	].

	^ true
]

{ #category : #accessing }
SYMLStructure >> computeInstanceSizes [
	| slotType slotSize slotAlignment |
	hasComputeInstanceSizes ifTrue: [ ^ self ].

	instanceDataSize := 0.
	instanceDataAlignment := 1.
	
	self slotsLayout doWithIndex: [ :slot :slotIndex |
		slotType := slot type.
		slotSize := slotType instanceSize.
		slotAlignment := slotType instanceAlignment.
		self isPacked ifTrue: [ slotAlignment := 1 ].

		"Apply the field alignment."
		instanceDataAlignment := instanceDataAlignment max: slotAlignment.
		instanceDataSize := instanceDataSize alignedTo: slotAlignment.
		self assert: (slot offset isNil or: [ slot offset = instanceDataSize]).
		slot offset: instanceDataSize.

		"Apply the field size."		
		instanceDataSize := instanceDataSize + slotSize.
	].
	
	hasComputeInstanceSizes := true.
]

{ #category : #accessing }
SYMLStructure >> concreteSSAType [
	<compileTime>
	self ensureConcreteStructureSSAType.
	^ self ssaType
]

{ #category : #accessing }
SYMLStructure >> defaultValue [
	^ self makeInstance
]

{ #category : #definition }
SYMLStructure >> definitionScopeClass [
	^ SYMLStructureScope
]

{ #category : #'initialization finalization' }
SYMLStructure >> ensureBasicInitializerIfNonTrivial [
	self hasNonTrivialBasicInitialization ifFalse: [ ^ self ].
	(methodDictionary includesKey: #basicInitialize) ifTrue: [ ^ self ].
	
	SYMLMessageMethod new
		module: module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: definitionNode ;
		parent: self;
		name: #basicInitialize;
		returnType: self compilationTarget voidType;
		addTrivialDefinition;
		semanticAnalysis.
]

{ #category : #'code generation' }
SYMLStructure >> ensureConcreteStructureSSAType [
	hasConcretedSSAType ifTrue: [ ^ self ].
	hasConcretedSSAType := true.
	self buildConcreteStructureSSAType
]

{ #category : #'initialization finalization' }
SYMLStructure >> ensureFinalizerIfNonTrivial [
	self hasNonTrivialFinalization ifFalse: [ ^ self ].
	(methodDictionary includesKey: #finalize) ifTrue: [ ^ self ].
	
	SYMLMessageMethod new
		module: module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: definitionNode ;
		parent: self;
		name: #finalize;
		returnType: self compilationTarget voidType;
		addTrivialDefinition;
		semanticAnalysis.
]

{ #category : #'initialization finalization' }
SYMLStructure >> ensureInitializerIfNonTrivial [
	self hasNonTrivialInitialization ifFalse: [ ^ self ].
	(methodDictionary includesKey: #initialize) ifTrue: [ ^ self ].
	
	SYMLMessageMethod new
		module: module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: definitionNode ;
		parent: self;
		name: #initialize;
		returnType: self compilationTarget voidType;
		addTrivialDefinition;
		semanticAnalysis.
]

{ #category : #accessing }
SYMLStructure >> fields [
	^ fields
]

{ #category : #'semantic analysis' }
SYMLStructure >> finalizeSSAVariable: ssaVariable with: builder [
	| finalizer |
	self hasNonTrivialInitialization ifFalse: [ ^ self ].
	finalizer := self lookupSelector: #finalize.
	finalizer generateSimpleSSACallWithArguments: {ssaVariable} with: builder
]

{ #category : #'code generation' }
SYMLStructure >> generateSSACode [
	super generateSSACode.
	self ensureConcreteStructureSSAType.
	self generateSSARTTI.
	children do: #generateSSACode
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAConstant: value forModule: aModule [
	| ssaValue |
	value ifNil: [ ^ SLVMConstant zeroInitializer: self ssaType ].
	ssaValue := value generateSSAValueForModule: aModule.
	^ value type == self
		ifTrue: [ ssaValue ]
		ifFalse: [ SLVMConstant value: ssaValue bitcast: self ssaType ]
	
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAImplicitBasicInitializationFor: receiver with: builder [
	builder withDebugPosition: definitionPosition  do: [ 
		self allFields do: [ :field |
			field basicInitializeSSAVariable: receiver with: builder
		]
	]

]

{ #category : #'initialization finalization' }
SYMLStructure >> generateSSAImplicitFinalizationFor: receiver with: builder [
	| superInitializer superInitializerFunction |
	builder withDebugPosition: definitionPosition  do: [ 
		fields do: [ :field |
			field finalizeSSAVariable: receiver with: builder
		].

		"Call implicitly the super finalizer."
		self supertype ifNotNil: [ :st |
			(st hasNonTrivialInitialization and: [(superInitializer := st lookupSelector: #finalize) isNotNil]) ifTrue: [
				superInitializerFunction := superInitializer ssaValue.
				builder call: superInitializerFunction arguments: { builder bitCast: receiver target: superInitializerFunction baseType arguments first }
			]
		].	
	]
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAImplicitInitializationFor: receiver with: builder [
	builder withDebugPosition: definitionPosition  do: [ 
		"Call implicitly the field initializer."
		fields do: [ :field |
			field initializeSSAVariable: receiver with: builder
		]
	]

]

{ #category : #'code generation' }
SYMLStructure >> generateSSARTTI [
	
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAValue: value withBuilder: aBuilder [
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialBasicInitialization [
	^ self hasNonTrivialGCBasicInitialization
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialFinalization [
	^ self hasNonTrivialGCFinalization
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialGCBasicInitialization [
	hasBasicInitialization ifNil: [ hasBasicInitialization := self checkNonTrivialBasicInitialization ].
	^ hasBasicInitialization
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialGCFinalization [
	hasFinalization ifNil: [ hasFinalization := self checkNonTrivialFinalization ].
	^ hasFinalization
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialGCInitialization [
	hasInitialization ifNil: [ hasInitialization := self checkNonTrivialInitialization ].
	^ hasInitialization
]

{ #category : #'initialization finalization' }
SYMLStructure >> hasNonTrivialInitialization [
	^ self hasNonTrivialGCInitialization
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	fields := OrderedCollection new.
	hasConcretedSSAType := false.
	analyzed := false.
	hasComputeInstanceSizes := false.
]

{ #category : #'code generation' }
SYMLStructure >> initializeSSAVariable: ssaVariable with: builder [
	| initializer |
	initializer := self lookupSelector: #initialize.
	initializer generateSimpleSSACallWithArguments: {ssaVariable} with: builder.
]

{ #category : #accessing }
SYMLStructure >> instanceAlignment [
	^ self instanceDataAlignment
]

{ #category : #accessing }
SYMLStructure >> instanceDataAlignment [
	<compileTime>
	self computeInstanceSizes.
	^ instanceDataAlignment
]

{ #category : #accessing }
SYMLStructure >> instanceDataSize [
	<compileTime>
	self computeInstanceSizes.
	^ instanceDataSize
]

{ #category : #accessing }
SYMLStructure >> instanceSize [
	^ self instanceDataSize
]

{ #category : #testing }
SYMLStructure >> isCompileTimeByDefault [
	^ false
]

{ #category : #testing }
SYMLStructure >> isPODType [
	isPODType ifNil: [ isPODType := self checkPODType ].
	^ isPODType
]

{ #category : #accessing }
SYMLStructure >> isPacked [
	<compileTime>
	^ self hasFlag: #packed
]

{ #category : #'symbol lookup' }
SYMLStructure >> lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock [
	<compileTime>
	symbols at: symbol ifPresent: [ :binding |
		binding isFieldVariable ifTrue: [
			^ ifPresentBlock value: (binding bindingForReceiver: receiver symbol: symbol)
		].
	].
	^ super lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock
]

{ #category : #'as yet unclassified' }
SYMLStructure >> makeInstance [
	self semanticAnalysis.
	^ SYMLStructureInstance new type: self;
		slots: (self slotsLayout collect: [:field | field defaultValue unwrapSysmelValue ]);
		yourself
]

{ #category : #'semantic analysis' }
SYMLStructure >> mangledName [
	| escapedName |
	^ ByteString streamContents: [ :out |
		escapedName := self validName sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $S;
			print: escapedName size;
			nextPutAll: escapedName.
	]
]

{ #category : #accessing }
SYMLStructure >> packed [
	<compileTime>
	self addFlag: #packed
]

{ #category : #printing }
SYMLStructure >> printOn: aStream [
	aStream nextPutAll: 'structure '; nextPutAll: self printingName
]

{ #category : #'semantic analysis' }
SYMLStructure >> semanticAnalysis [
	super semanticAnalysis.
	analyzed ifTrue: [ ^ self ].
	analyzed := true.
	
	self buildLayout.
	children do: #semanticAnalysis.
	
	self
		ensureBasicInitializerIfNonTrivial;
		ensureInitializerIfNonTrivial;
		ensureFinalizerIfNonTrivial.
]

{ #category : #'semantic analysis' }
SYMLStructure >> slotsLayout [
	slotsLayout ifNil: [ self buildLayout ].
	^ slotsLayout
]

{ #category : #'code generation' }
SYMLStructure >> structureSSAType [
	<compileTime>
	structureSSAType ifNil: [ structureSSAType := self buildStructureSSAType].
	^ structureSSAType
]

{ #category : #accessing }
SYMLStructure >> structureTypeInstanceAlignment [
	<compileTime>
	^ self instanceAlignment
]

{ #category : #accessing }
SYMLStructure >> structureTypeInstanceSize [
	<compileTime>
	^ self instanceSize
]

{ #category : #'as yet unclassified' }
SYMLStructure >> typeKindBaseTrait [
	^ self compilationTarget structureTypeTrait
]
