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
		'isPODType'
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
	
	builder := SYMLStructureSlotsLayoutBuilder new.
	self allFields do: [ :field | builder addField: field ].
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

{ #category : #testing }
SYMLStructure >> checkNonTrivialFinalization [
	self supertype ifNotNil: [ :st | st hasNonTrivialGCFinalization ifTrue: [^ true]].
	super checkNonTrivialFinalization ifTrue: [ ^ true ].
	fields do: [ :field |
		field type checkNonTrivialFinalization ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : #testing }
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

{ #category : #'code generation' }
SYMLStructure >> ensureConcreteStructureSSAType [
	hasConcretedSSAType ifTrue: [ ^ self ].
	hasConcretedSSAType := true.
	self buildConcreteStructureSSAType
]

{ #category : #'semantic analysis' }
SYMLStructure >> ensureFinalizerIfNonTrivial [
	self hasNonTrivialFinalization ifFalse: [ ^ self ].
	(self lookupSelector: #finalize) ifNotNil: [ ^ self ].
	
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

{ #category : #'semantic analysis' }
SYMLStructure >> ensureInitializerIfNonTrivial [
	self hasNonTrivialInitialization ifFalse: [ ^ self ].
	(self lookupSelector: #initialize) ifNotNil: [ ^ self ].
	
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
	self assert: finalizer isNotNil.
	self assert: ssaVariable type = finalizer ssaValue type baseType arguments first.
	builder call: finalizer ssaValue arguments: {ssaVariable}
]

{ #category : #'code generation' }
SYMLStructure >> generateSSACode [
	super generateSSACode.
	self ensureConcreteStructureSSAType.
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
	| superInitializer superInitializerFunction |
	builder withDebugPosition: definitionPosition  do: [ 
		"Call implicitly the super initializer."
		self supertype ifNotNil: [ :st |
			(st hasNonTrivialInitialization and: [(superInitializer := st lookupSelector: #initialize) isNotNil]) ifTrue: [
				superInitializerFunction := superInitializer ssaValue.
				builder call: superInitializerFunction arguments: { builder bitCast: receiver target: superInitializerFunction baseType arguments first }
			]
		].
	
		fields do: [ :field |
			field initializeSSAVariable: receiver with: builder
		]
	]

]

{ #category : #'code generation' }
SYMLStructure >> generateSSAValue: value withBuilder: aBuilder [
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #testing }
SYMLStructure >> hasNonTrivialFinalization [
	^ self hasNonTrivialGCFinalization
]

{ #category : #testing }
SYMLStructure >> hasNonTrivialGCFinalization [
	hasFinalization ifNil: [ hasFinalization := self checkNonTrivialFinalization ].
	^ hasFinalization
]

{ #category : #testing }
SYMLStructure >> hasNonTrivialGCInitialization [
	hasInitialization ifNil: [ hasInitialization := self checkNonTrivialInitialization ].
	^ hasInitialization
]

{ #category : #testing }
SYMLStructure >> hasNonTrivialInitialization [
	^ self hasNonTrivialGCInitialization
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	fields := OrderedCollection new.
	hasConcretedSSAType := false.
	analyzed := false.
]

{ #category : #'semantic analysis' }
SYMLStructure >> initializeSSAVariable: ssaVariable with: builder [
	| initializer |
	self hasNonTrivialInitialization ifFalse: [
		self allFields do: [ :field |
			field initializeSSAVariable: ssaVariable with: builder
		].
		^ self
	].

	initializer := self lookupSelector: #initialize.
	self assert: initializer isNotNil.
	self assert: ssaVariable type = initializer ssaValue type baseType arguments first.
	builder call: initializer ssaValue arguments: {ssaVariable}
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
	
	self ensureInitializerIfNonTrivial.
	self ensureFinalizerIfNonTrivial.
]

{ #category : #'semantic analysis' }
SYMLStructure >> slotsLayout [
	^ slotsLayout ifNil: [ self buildLayout ]
]

{ #category : #'code generation' }
SYMLStructure >> structureSSAType [
	<compileTime>
	structureSSAType ifNil: [ structureSSAType := self buildStructureSSAType].
	^ structureSSAType
]

{ #category : #'as yet unclassified' }
SYMLStructure >> typeKindBaseTrait [
	^ self compilationTarget structureTypeTrait
]
