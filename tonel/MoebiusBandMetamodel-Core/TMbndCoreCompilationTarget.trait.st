Trait {
	#name : #TMbndCoreCompilationTarget,
	#instVars : [
		'coreDefinitionsModule',
		'basicTypes'
	],
	#category : #'MoebiusBandMetamodel-Core-CompilationTarget'
}

{ #category : #initialization }
TMbndCoreCompilationTarget >> addBasicFloatTypeWithSize: size alignment: alignment name: name [
	^ self addBasicType: (MbndPrimitiveFloatType new
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		yourself)
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> addBasicFloatTypeWithSize: size name: name [
	^ self addBasicFloatTypeWithSize: size alignment: size name: name
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> addBasicIntegerTypeWithSize: size alignment: alignment signed: signed name: name [
	^ self addBasicType: (MbndPrimitiveIntegerType new
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		signed: signed;
		yourself)
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> addBasicIntegerTypeWithSize: size signed: signed name: name [
	^ self addBasicIntegerTypeWithSize: size alignment: size signed: signed name: name
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> addBasicType: basicType [
	basicType name ~= basicType class typeName ifTrue: [
		self assert: basicType type isNil.
		basicType type: (MbndSimpleMetaType new
			instanceType: basicType;
			type: self simpleMetaType;
			supertype: (basicTypes at: basicType class typeName) type;
			yourself)
	].

	basicTypes at: basicType name put: basicType.
	^ basicType
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> booleanType [
	^ self getBasicTypeNamed: #BooleanBit
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule [
	^ coreDefinitionsModule
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule: anObject [
	coreDefinitionsModule := anObject
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> float16Type [
	^ self getBasicTypeNamed: #Float16
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> float32Type [
	^ self getBasicTypeNamed: #Float32
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> float64Alignment [
	^ self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> float64Type [
	^ self getBasicTypeNamed: #Float64
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> getBasicTypeNamed: typeName [
	^ basicTypes at: typeName
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeBasicTypes [
	| basicType |
	basicTypes := Dictionary new.
	MbndBasicType withAllSubclassesDo: [ :sc |
		sc typeName ifNotNil: [ 
			basicType := sc new compilationTarget: self.
			basicTypes at: basicType name put: basicType
		]
	].

	self linkMetaHierarchy.
	self
		addBasicType: (MbndPrimitiveBooleanType new name: #BooleanBit; yourself);
		addBasicIntegerTypeWithSize: 1 signed: false name: #UInt8;
		addBasicIntegerTypeWithSize: 2 signed: false name: #UInt16;
		addBasicIntegerTypeWithSize: 4 signed: false name: #UInt32;
		addBasicIntegerTypeWithSize: 8 alignment: self int64Alignment signed: false name: #UInt64;
		
		addBasicIntegerTypeWithSize: 1 signed: true name: #Int8;
		addBasicIntegerTypeWithSize: 2 signed: true name: #Int16;
		addBasicIntegerTypeWithSize: 4 signed: true name: #Int32;
		addBasicIntegerTypeWithSize: 8 alignment: self int64Alignment signed: true name: #Int64;

		addBasicFloatTypeWithSize: 2 name: #Float16;
		addBasicFloatTypeWithSize: 4 name: #Float32;
		addBasicFloatTypeWithSize: 8 alignment: self float64Alignment name: #Float64;
		yourself

]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> int16Type [
	^ self getBasicTypeNamed: #Int16
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> int32Type [
	^ self getBasicTypeNamed: #Int32
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> int64Alignment [
	^ self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> int64Type [
	^ self getBasicTypeNamed: #Int64
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> int8Type [
	^ self getBasicTypeNamed: #Int8
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> linkMetaHierarchy [
	| simpleMetaType |
	simpleMetaType := basicTypes at: MbndSimpleMetaType typeName.
	
	basicTypes valuesDo: [ :bt |
		"Link with the super type."
		(bt class superclass respondsTo: #typeName) ifTrue: [ 
			bt class superclass typeName ifNotNil: [ :superTypeName |
				basicTypes at: superTypeName ifPresent: [ :superType |
					bt supertype: superType
				]
			].
		].
	
		"Create the meta type."
		bt type ifNil: [ 
			bt type: (MbndSimpleMetaType new
				instanceType: bt;
				type: simpleMetaType;
				yourself).
		]
	].

	"Link the meta types super types"
	basicTypes valuesDo: [ :bt |
		bt supertype ifNotNil: [ 
			bt type supertype ifNil: [
				bt type supertype: bt supertype type.
			]
		]
	]
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalBooleanFalseType [
	^ self getBasicTypeNamed: #_LiteralBooleanFalse
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalBooleanTrueType [
	^ self getBasicTypeNamed: #_LiteralBooleanTrue
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalBooleanType [
	^ self getBasicTypeNamed: #_LiteralBoolean
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalFloatType [
	^ self getBasicTypeNamed: #_LiteralFloat
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalIntegerType [
	^ self getBasicTypeNamed: #_LiteralInteger
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalStringType [
	^ self getBasicTypeNamed: #_LiteralString
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> literalSymbolType [
	^ self getBasicTypeNamed: #_LiteralSymbol
]

{ #category : #'builder methods' }
TMbndCoreCompilationTarget >> lookupTypeWithName: typeName [
	^ basicTypes at: typeName ifAbsent: [ nil ]

]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> metaBuilderInstanceType [
	^ self getBasicTypeNamed: MbndMetaBuilderInstanceType typeName
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> opaqueType [
	^ self getBasicTypeNamed: MbndOpaqueType typeName
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> returnType [
	^ self getBasicTypeNamed: #_ReturnType
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> simpleMetaType [
	^ self getBasicTypeNamed: MbndSimpleMetaType typeName
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> uint16Type [
	^ self getBasicTypeNamed: #UInt16
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> uint32Type [
	^ self getBasicTypeNamed: #UInt32
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> uint64Type [
	^ self getBasicTypeNamed: #UInt64
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> uint8Type [
	^ self getBasicTypeNamed: #UInt8
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> undefinedType [
	^ self getBasicTypeNamed: MbndUndefinedType typeName
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> voidType [
	^ self getBasicTypeNamed: MbndVoidType typeName
]
