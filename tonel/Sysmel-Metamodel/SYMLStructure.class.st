Class {
	#name : #SYMLStructure,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'fields',
		'hasConcretedSSAType',
		'analyzed',
		'structureSSAType',
		'slotsLayout'
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

{ #category : #accessing }
SYMLStructure >> fields [
	^ fields
]

{ #category : #'code generation' }
SYMLStructure >> generateSSACode [
	super generateSSACode.
	self ensureConcreteStructureSSAType.
	children do: #generateSSACode
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAConstant: value forModule: aModule [
	| ssaValue actualValue |
	actualValue := value ifNil: [ self makeInstance ].
	ssaValue := actualValue generateSSAValueForModule: aModule.
	^ actualValue type == self
		ifTrue: [ ssaValue ]
		ifFalse: [ SLVMConstant value: ssaValue bitcast: self ssaType ]
	
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAValue: value withBuilder: aBuilder [
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	fields := OrderedCollection new.
	hasConcretedSSAType := false.
	analyzed := false.
]

{ #category : #initialization }
SYMLStructure >> initializeSSAVariable: ssaVariable builder: builder [
	fields do: [ :field |
		field initializeSSAVariable: ssaVariable builder: builder
	]
]

{ #category : #testing }
SYMLStructure >> isCompileTimeByDefault [
	^ false
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
	children do: #semanticAnalysis
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
