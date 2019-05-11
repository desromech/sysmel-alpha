Trait {
	#name : #TMbndCoreCompilationTarget,
	#instVars : [
		'coreDefinitionsModule',
		'basicTypes',
		'pointerTypes',
		'referenceTypes',
		'functionTypes',
		'decoratedTypes',
		'arithmeticCoercionTable'
	],
	#traits : 'TMbndAbstractCompilationTarget',
	#classTraits : 'TMbndAbstractCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicFloatTypeWithSize: size alignment: alignment name: name [
	^ self addBasicType: (MbndPrimitiveFloatType basicNew
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		yourself)
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicFloatTypeWithSize: size name: name [
	^ self addBasicFloatTypeWithSize: size alignment: size name: name
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicIntegerTypeWithSize: size alignment: alignment signed: signed name: name [
	^ self addBasicType: (MbndPrimitiveIntegerType basicNew
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		signed: signed;
		yourself)
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicIntegerTypeWithSize: size signed: signed name: name [
	^ self addBasicIntegerTypeWithSize: size alignment: size signed: signed name: name
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicType: basicType [
	self ensureBasicTypeIsLinkedToTheHierarchy: basicType.
	basicTypes at: basicType name put: basicType.
	^ basicType
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeArithmeticCoercionTypeFor: leftType with: rightType [
	(leftType isReferenceType or:
	[ leftType isDecorationType or:
	[ rightType isReferenceType or:
	[ rightType isDecorationType ]]]) ifTrue: [
		^ self computeArithmeticCoercionTypeFor: leftType withoutReferences withoutDecorations with: rightType withoutReferences withoutDecorations
	].

	arithmeticCoercionTable at: { leftType .  rightType} ifPresent: [ :found | ^ found  ].
	leftType == rightType ifTrue: [ ^ leftType ].
	^ nil
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeConditionalResultCoercionTypeFor: leftType with: rightType [
	leftType isVoidType ifTrue: [ ^ leftType ].
	rightType isVoidType ifTrue: [ ^ rightType ].
	leftType == rightType ifTrue: [ ^ leftType ].

	^ self computeArithmeticCoercionTypeFor: leftType with: rightType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule [
	^ coreDefinitionsModule
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule: anObject [
	coreDefinitionsModule := anObject
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> ensureBasicTypeIsLinkedToTheHierarchy: basicType [
	basicType module ifNil: [ 
		basicType definitionModule: coreDefinitionsModule.
	].

	basicType name ~= basicType class typeName ifTrue: [ 
		basicType supertype: (basicTypes at: basicType class typeName)
	].
	self ensureTypeHasSimpleMetaType: basicType.

]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> ensureTypeHasSimpleMetaType: type [
	type type ifNotNil: [ ^ self ].
	
	type type: (MbndSimpleMetaType basicNew
		definitionModule: coreDefinitionsModule;
		instanceType: type;
		type: self simpleMetaType;
		supertype: type supertype type;
		initializeNonTraitType;
		yourself)
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic [
	^ functionTypes at: { argumentTypes . returnType . callingConvention . cvariadic} ifAbsentPut: [
		| result |
		result := MbndFunctionType new
			name: nil;
			argumentTypes: argumentTypes;
			returnType: returnType;
			callingConvention: callingConvention;
			cvariadic: cvariadic;
			yourself.
		self ensureBasicTypeIsLinkedToTheHierarchy: result.
		result
	]
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> getBasicTypeNamed: typeName [
	^ basicTypes at: typeName
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeArithmeticCoercionTable [
	| left right coercionType |
	arithmeticCoercionTable := Dictionary new.
	
	#(
		"Small integer. Operate alwas as Int32"
		(Int8 Int8 Int32)
		(UInt8 UInt8 Int32)
		(Int8 UInt8 Int32)

		(Int16 Int16 Int32)
		(UInt16 UInt16 Int32)
		(Int16 UInt16 Int32)

		(Int8 Int16 Int32)	
		(Int8 UInt16 Int32)
		(UInt8 Int16 Int32)
		(UInt8 UInt16 Int32)
		
		"Integer coercions."
		(Int8 Int32 Int32)
		(Int16 Int32 Int32)
		(UInt8 Int32 Int32)
		(UInt16 Int32 Int32)

		(UInt8 UInt32 UInt32)
		(UInt16 UInt32 UInt32)

		(Int8 Int64 Int64)
		(Int16 Int64 Int64)
		(Int32 Int64 Int64)
		(UInt8 Int64 Int64)
		(UInt16 Int64 Int64)
		(UInt32 Int64 Int64)

		(UInt8 UInt64 UInt64)
		(UInt16 UInt64 UInt64)
		(UInt32 UInt64 UInt64)
		
		"Larger integers."
		(Int32 Int32 Int32)
		(UInt32 UInt32 UInt32)
		(Int64 Int64 Int64)
		(UInt64 UInt64 UInt64)

		(Int32 UInt32 Int64)

		(UInt64 Int64 nil)

		"Integer float16."
		(Int8 Float16 Float16)
		(UInt8 Float16 Float16)
		(Int16 Float16 Float16)
		(UInt16 Float16 Float16)
		(Int32 Float16 nil)
		(UInt32 Float16 nil)
		(Int64 Float16 nil)
		(UInt64 Float16 nil)
		
		"Integer float32."
		(Int8 Float32 Float32)
		(UInt8 Float32 Float32)
		(Int16 Float32 Float32)
		(UInt16 Float32 Float32)
		(Int32 Float32 Float32)
		(UInt32 Float32 Float32)
		(Int64 Float32 nil)
		(UInt64 Float32 nil)

		"Integer float64."
		(Int8 Float64 Float64)
		(UInt8 Float64 Float64)
		(Int16 Float64 Float64)
		(UInt16 Float64 Float64)
		(Int32 Float64 Float64)
		(UInt32 Float64 Float64)
		(Int64 Float64 Float64)
		(UInt64 Float64 Float64)
		
		"Float float."
		(Float16 Float16 Float16)
		(Float32 Float32 Float32)
		(Float64 Float64 Float64)

		(Float16 Float32 Float32)
		(Float16 Float64 Float64)

		(Float32 Float64 Float64)
		
	) do: [ :coercionRule |
		left := self getBasicTypeNamed: coercionRule first.
		right := self getBasicTypeNamed: coercionRule second.
		coercionType := coercionRule third ifNotNil: [:typeName | self getBasicTypeNamed: typeName].
		
		arithmeticCoercionTable at: { left . right } put: coercionType.
		arithmeticCoercionTable at: { right . left } put: coercionType.
	].
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeBasicTypes [
	| basicType | 
	basicTypes := Dictionary new.
	MbndBasicType withAllSubclassesDo: [ :sc |
		sc typeName ifNotNil: [ 
			basicType := sc basicNew
				initializeBasicTypeTrait;
				definitionModule: coreDefinitionsModule.
			basicTypes at: sc typeName put: basicType
		]
	].

	self linkMetaHierarchy.
	self
		addBasicType: (MbndPrimitiveBooleanType basicNew name: #BooleanBit; yourself);
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
		yourself.
		
	basicTypes valuesDo: [:bt | 
		bt initializeNonTraitType.
		bt type initializeNonTraitType
	].
	
	self pointerSize = 4 ifTrue: [ 
		basicTypes
			at: #UIntPointer put: self uint32Type;
			at: #IntPointer put: self int32Type
	] ifFalse: [ 
		basicTypes
			at: #UIntPointer put: self uint64Type;
			at: #IntPointer put: self int64Type
	].

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeDerivedTypeCaches [
	pointerTypes := WeakValueDictionary new.
	referenceTypes := WeakValueDictionary new.
	functionTypes := WeakValueDictionary new.
	decoratedTypes := WeakValueDictionary new.
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeTypeSystem [
	self
		initializeDerivedTypeCaches;
		initializeBasicTypes;
		initializeArithmeticCoercionTable
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
			bt type: (MbndSimpleMetaType basicNew
				definitionModule: coreDefinitionsModule;
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

{ #category : #'builder methods' }
TMbndCoreCompilationTarget >> lookupTypeWithName: typeName [
	^ basicTypes at: typeName ifAbsent: [ nil ]

]

{ #category : #'instance creation' }
TMbndCoreCompilationTarget >> newCodeModuleGenerator [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> pointerFor: addressSpace to: baseType [
	^ pointerTypes at: { baseType . addressSpace } ifAbsentPut: [
		| result |
		result := MbndPointerType new
			name: nil;
			addressSpace: addressSpace;
			baseType: baseType;
			yourself.
		self ensureBasicTypeIsLinkedToTheHierarchy: result.
		result
	]
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> referenceFor: addressSpace to: baseType [
	^ referenceTypes at: { baseType . addressSpace } ifAbsentPut: [
		| result |
		result := MbndReferenceType basicNew
			name: nil;
			addressSpace: addressSpace;
			baseType: baseType;
			initializeNonTraitType;
			yourself.
		self ensureBasicTypeIsLinkedToTheHierarchy: result.
		result
	]
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> type: baseType withDecorations: decorations [
	^ decoratedTypes at: { baseType . decorations } ifAbsentPut: [
		| result |
		result := MbndDecoratedType basicNew
			name: nil;
			baseType: baseType;
			decorations: decorations;
			initializeNonTraitType;
			yourself.
		self ensureBasicTypeIsLinkedToTheHierarchy: result.
		result
	]
]
