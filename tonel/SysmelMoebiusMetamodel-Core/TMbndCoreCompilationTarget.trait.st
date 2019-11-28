Trait {
	#name : #TMbndCoreCompilationTarget,
	#instVars : [
		'coreDefinitionsModule',
		'basicTypes',
		'pointerTypes',
		'referenceTypes',
		'functionTypes',
		'decoratedTypes',
		'arithmeticCoercionTable',
		'variantUnions',
		'arrayTypes',
		'tupleTypes',
		'specificCompilerObjects',
		'blockClosureTypes',
		'nativePrefixedStringLiteralType',
		'associationTypes',
		'primitiveVectorTypes',
		'primitiveMatrixTypes',
		'dynamicObjectType',
		'managedObjectModel',
		'gcClassVariableDataArrayTypes'
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

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> arrayOf: elementType elements: elementCount [
	^ arrayTypes getOrCreateInstanceWithArguments: { elementType . elementCount }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> associationKey: keyType value: valueType [
	(keyType isLiteralValueType or: [ valueType isLiteralValueType ]) ifTrue: [ ^ self literalAssociationType ].
	^ associationTypes getOrCreateInstanceWithArguments: { keyType . valueType }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> blockClosureTypeWithSignature: functionType [
	^ blockClosureTypes getOrCreateInstanceWithArguments: { functionType }
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
	leftType isCompilerObjectType ifTrue: [ ^ leftType ].
	rightType isCompilerObjectType ifTrue: [ ^ leftType ].
	^ nil
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeArithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [
	| bestLeftType bestRightType |

	bestLeftType := leftType bestConcreteTypeForLiteralValueNode: leftNode inScope: aScope.
	bestRightType := rightType bestConcreteTypeForLiteralValueNode: rightNode inScope: aScope.

	"Promote to matrix"
	(bestLeftType isPrimitiveMatrixType or: [ bestRightType isPrimitiveMatrixType ]) ifTrue: [
		^ self computeMatrixArithmeticCoercionTypeFor: bestLeftType with: bestRightType leftNode: leftNode rightNode: rightNode inScope: aScope
	].
	
	"Promote to vector"
	(bestLeftType isPrimitiveVectorType or: [ bestRightType isPrimitiveVectorType ]) ifTrue: [
		^ self computeVectorArithmeticCoercionTypeFor: bestLeftType with: bestRightType leftNode: leftNode rightNode: rightNode inScope: aScope
	].
	
	"Positive literal , Unsigned type"
	(leftType isLiteralIntegerType and: [leftNode value >= 0 and: [ bestLeftType isSigned
	 and: [rightType isPrimitiveIntegerType and: [rightType isUnsigned]]]]) ifTrue: [
		bestLeftType := bestLeftType asUnsignedType
	].

	"Unsigned type , Positive literal"
	(rightType isLiteralIntegerType and: [rightNode value >= 0 and: [ bestRightType isSigned
	 and: [leftType isPrimitiveIntegerType and: [leftType isUnsigned]]]]) ifTrue: [
		bestRightType := bestRightType asUnsignedType
	].


	^ self computeArithmeticCoercionTypeFor: bestLeftType with: bestRightType.
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeConditionalResultCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [

	| leftValueType rightValueType |
	leftType isReturnType ifTrue: [ ^ rightType ].
	rightType isReturnType ifTrue: [ ^ leftType ].
	leftType isVoidType ifTrue: [ ^ leftType ].
	rightType isVoidType ifTrue: [ ^ rightType ].
	
	leftValueType := leftType withoutReferences.
	rightValueType := rightType withoutReferences.
	leftValueType == rightValueType ifTrue: [ ^ leftValueType ].

	

	^ (self computeArithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope)
		ifNil: [self voidType].
	
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeMatrixArithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [
	| matrixType firstElementType firstElementTypeNode secondElementType secondElementTypeNode elementCoercionType |
	leftType isPrimitiveVectorType ifTrue: [ ^ nil ].
	rightType isPrimitiveVectorType ifTrue: [ ^ nil ].

	(leftType isPrimitiveMatrixType and: [rightType isPrimitiveMatrixType]) ifTrue: [ 
		"Matrix - Matrix, the dimensions must match."
		(leftType rows ~= rightType rows or: [leftType columns ~= rightType columns]) ifTrue: [
			^ nil.
		].
			
		matrixType := leftType.
		firstElementType := leftType elementType.
		firstElementTypeNode := MbndAstNode dummy.
		secondElementType := rightType elementType.
		secondElementTypeNode := MbndAstNode dummy.
	] ifFalse: [ 
		leftType isPrimitiveMatrixType ifTrue: [
			"Matrix - Scalar"
			matrixType := leftType.
			firstElementType := leftType elementType.
			firstElementTypeNode := MbndAstNode dummy.
			secondElementType := rightType.
			secondElementTypeNode := rightNode.
		] ifFalse: [ 
			"Scalar - Matrix"
			matrixType := rightType.
			firstElementType := leftType.
			firstElementTypeNode := leftNode.
			secondElementType := rightType elementType.
			secondElementTypeNode := MbndAstNode dummy.
		]
	].
	
	self assert: matrixType isPrimitiveMatrixType.
	elementCoercionType := self computeArithmeticCoercionTypeFor: firstElementType with: secondElementType leftNode: firstElementTypeNode rightNode: secondElementTypeNode inScope: aScope.
	elementCoercionType ifNil: [ ^ nil ].
	
	^ elementCoercionType primitiveMatrixWithRows: matrixType rows columns: matrixType columns
]

{ #category : #coercing }
TMbndCoreCompilationTarget >> computeVectorArithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope [
	| vectorType firstElementType firstElementTypeNode secondElementType secondElementTypeNode elementCoercionType |
	(leftType isPrimitiveVectorType and: [rightType isPrimitiveVectorType]) ifTrue: [ 
		"Vector - Vector, the dimensions must match."
		(leftType elements ~= rightType elements) ifTrue: [
			^ nil.
		].
			
		vectorType := leftType.
		firstElementType := leftType elementType.
		firstElementTypeNode := MbndAstNode dummy.
		secondElementType := rightType elementType.
		secondElementTypeNode := MbndAstNode dummy.
	] ifFalse: [ 
		leftType isPrimitiveVectorType ifTrue: [
			"Vector - Scalar"
			vectorType := leftType.
			firstElementType := leftType elementType.
			firstElementTypeNode := MbndAstNode dummy.
			secondElementType := rightType.
			secondElementTypeNode := rightNode.
		] ifFalse: [ 
			"Scalar - Vector"
			vectorType := rightType.
			firstElementType := leftType.
			firstElementTypeNode := leftNode.
			secondElementType := rightType elementType.
			secondElementTypeNode := MbndAstNode dummy.

		]
	].
	
	self assert: vectorType isPrimitiveVectorType.
	elementCoercionType := self computeArithmeticCoercionTypeFor: firstElementType with: secondElementType leftNode: firstElementTypeNode rightNode: secondElementTypeNode inScope: aScope.
	elementCoercionType ifNil: [ ^ nil ].
	
	^ elementCoercionType primitiveVectorWithElements: vectorType elements
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule [
	^ coreDefinitionsModule
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> coreDefinitionsModule: anObject [
	coreDefinitionsModule := anObject
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> createNamedType: name ofKind: typeKindClass [
	^ (self ensureBasicTypeIsLinkedToTheHierarchy: typeKindClass basicNew)
		name: name;
		initializeNonTraitType.
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> createSystemProvidedTypeTemplate: templateName doing: aBlock [
	| template |
	template := MbndSystemProvidedTypeTemplate new
		name: templateName;
		mainDefinitionConstructionBlock: aBlock;
		compilationTarget: self;
		yourself.
	^ template
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> dynamicObjectType [
	^ dynamicObjectType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> dynamicObjectType: anObjectType [
	dynamicObjectType := anObjectType
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
	^ basicType

]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> ensureTypeHasSimpleMetaType: type [
	| metaTypeType |
	type type ifNotNil: [ ^ self ].
	
	metaTypeType := self simpleMetaType.
	type supertype type type ifNotNil: [ :stMetaType |
		metaTypeType := stMetaType.
	].
	type type: (type createMetaTypeBasicInstance
		definitionModule: coreDefinitionsModule;
		instanceType: type;
		type: metaTypeType;
		supertype: type supertype type;
		initializeNonTraitType;
		yourself)
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic [
	^ functionTypes getOrCreateInstanceWithArguments: { argumentTypes . returnType . callingConvention . cvariadic}
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> gcClassVariableDataArrayOf: elementType [
	^ gcClassVariableDataArrayTypes getOrCreateInstanceWithArguments: { elementType }
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> getBasicTypeNamed: typeName [
	^ basicTypes at: typeName
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> identityHashForSymbol: symbol [
	^ self managedObjectModel identityHashForSymbol: symbol
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
TMbndCoreCompilationTarget >> initializeArithmeticConversionRules [
	| int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	int8Type := self int8Type.
	int16Type := self int16Type.
	int32Type := self int32Type.
	int64Type := self int64Type.
	uint8Type := self uint8Type.
	uint8Type := self uint8Type.
	uint16Type := self uint16Type.
	uint32Type := self uint32Type.
	uint64Type := self uint64Type.
	float16Type := self float16Type.
	float32Type := self float32Type.
	float64Type := self float64Type.
	
	"Positive literal -> Unsigned type"
	int8Type | int16Type | int32Type | int64Type addImplicitConversionTo:
		uint8Type | uint16Type | uint32Type | uint64Type
	rule: MbndPositiveLiteralToUnsignedTypeConversionRule.
	
	"Bit cast"
	int64Type addExplicitConversionTo: uint64Type rule: MbndBitCastTypeConversionRule.
	uint64Type addExplicitConversionTo: int64Type rule: MbndBitCastTypeConversionRule.
	int32Type addExplicitConversionTo: uint32Type rule: MbndBitCastTypeConversionRule.
	uint32Type addExplicitConversionTo: int32Type rule: MbndBitCastTypeConversionRule.
	int16Type addExplicitConversionTo: uint16Type rule: MbndBitCastTypeConversionRule.
	uint16Type addExplicitConversionTo: int16Type rule: MbndBitCastTypeConversionRule.
	int8Type addExplicitConversionTo: uint8Type rule: MbndBitCastTypeConversionRule.
	uint8Type addExplicitConversionTo: int8Type rule: MbndBitCastTypeConversionRule.
	
	"Truncate"
	int64Type | uint64Type |
	int32Type | uint32Type |
	int16Type | uint16Type
		addExplicitConversionTo: int8Type | uint8Type rule: MbndTruncateTypeConversionRule.
	int64Type | uint64Type |
	int32Type | uint32Type
		addExplicitConversionTo: int16Type | uint16Type rule: MbndTruncateTypeConversionRule.
	int64Type | uint64Type
		addExplicitConversionTo: int32Type | uint32Type rule: MbndTruncateTypeConversionRule.
	
	"Sign extension"
	int8Type | int16Type | int32Type addConversionTo:
		int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	int8Type | int16Type addConversionTo:
		int32Type | uint32Type | int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	int8Type addConversionTo:
		int16Type | uint16Type | int32Type | uint32Type | int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	
	"Zero extension"
	uint8Type | uint16Type | uint32Type addConversionTo:
		int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
	uint8Type | uint16Type addConversionTo:
		int32Type | uint32Type | int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
	uint8Type addConversionTo:
		int16Type | uint16Type | int32Type | uint32Type | int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
	
	"Int -> FP"
	int8Type | uint8Type |
	int16Type | uint16Type |
	int32Type | uint32Type |
	int64Type | uint64Type addConversionTo:
		float16Type | float32Type | float64Type
		rule: MbndIntegerToFloatingPointTypeConversionRule.
	
	"FP -> Int"
	float16Type | float32Type | float64Type addExplicitConversionTo:
		int8Type | uint8Type |
		int16Type | uint16Type |
		int32Type | uint32Type |
		int64Type | uint64Type
		rule: MbndFloatingPointToIntegerTypeConversionRule.

	"FP -> FP"
	float16Type addConversionTo: float32Type | float64Type rule: MbndFloatingPointSizeTypeConversionRule.

	float32Type addConversionTo: float64Type rule: MbndFloatingPointSizeTypeConversionRule.
	float32Type addExplicitConversionTo: float16Type rule: MbndFloatingPointSizeTypeConversionRule.

	float64Type addExplicitConversionTo: float16Type | float32Type rule: MbndFloatingPointSizeTypeConversionRule.

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeBasicTypes [
	| basicType typesToInitialize | 
	basicTypes := Dictionary new.
	MbndBasicType withAllSubclassesDo: [ :sc |
		sc typeName ifNotNil: [ 
			basicType := sc basicNew
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

	typesToInitialize := basicTypes values asArray.
	self pointerSize = 4 ifTrue: [ 
		basicTypes
			at: #UIntPointer put: self uint32Type;
			at: #IntPointer put: self int32Type
	] ifFalse: [ 
		basicTypes
			at: #UIntPointer put: self uint64Type;
			at: #IntPointer put: self int64Type
	].

	typesToInitialize do: [:bt | 
		bt initializeNonTraitType.
		bt type initializeNonTraitType
	].

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeDerivedTypeCaches [
	pointerTypes := self createSystemProvidedTypeTemplate: #_PointerTypeTemplate
		doing: [ :baseType :addressSpace |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPointerType basicNew)
				addressSpace: addressSpace;
				baseType: baseType;
				initializeNonTraitType;
				yourself.
		].

	referenceTypes := self createSystemProvidedTypeTemplate: #_ReferenceTypeTemplate
		doing: [ :baseType :addressSpace |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndReferenceType basicNew)
				addressSpace: addressSpace;
				baseType: baseType;
				initializeNonTraitType;
				yourself.
	].

	functionTypes := self createSystemProvidedTypeTemplate: #_FunctionTypeTemplate
		doing: [ :argumentTypes :returnType :callingConvention :cvariadic |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndFunctionType basicNew)
				argumentTypes: argumentTypes;
				returnType: returnType;
				callingConvention: callingConvention;
				cvariadic: cvariadic;
				initializeNonTraitType;
				yourself.
	].

	blockClosureTypes := self createSystemProvidedTypeTemplate: #_BlockClosureTypeTemplate
		doing: [ :functionType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndBlockClosureType basicNew)
				functionType: functionType;
				initializeNonTraitType;
				yourself.
	].

	decoratedTypes := self createSystemProvidedTypeTemplate: #_DecoratedTypeTemplate
		doing: [ :baseType :decorations |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndDecoratedType basicNew)
				baseType: baseType;
				decorations: decorations;
				initializeNonTraitType;
				yourself.
	].
	variantUnions := self createSystemProvidedTypeTemplate: #_VariantUnionTypeTemplate
		doing: [ :components |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndVariantUnionType basicNew)
				components: components;
				initializeNonTraitType;
				yourself.
	].

	arrayTypes := self createSystemProvidedTypeTemplate: #_BasicArrayTypeTemplate
		doing: [ :elementType :elementCount |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndArrayType basicNew)
				elementType: elementType;
				elements: elementCount;
				initializeNonTraitType;
				yourself.
	].

	gcClassVariableDataArrayTypes := self createSystemProvidedTypeTemplate: #_GCClassVariableDataArrayTypeTemplate
		doing: [ :elementType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndGCClassVariableDataArrayType basicNew)
				elementType: elementType;
				initializeNonTraitType;
				yourself.
	].

	tupleTypes := self createSystemProvidedTypeTemplate: #_TupleTypeTemplate
		doing: [ :elements |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndTupleType basicNew)
				elements: elements;
				initializeNonTraitType;
				yourself.
	].

	associationTypes := self createSystemProvidedTypeTemplate: #_AssociationTypeTemplate
		doing: [ :keyType :valueType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndAssociationType basicNew)
				keyType: keyType;
				valueType: valueType;
				initializeNonTraitType;
				yourself.
	].

	primitiveVectorTypes := self createSystemProvidedTypeTemplate: #_PrimitiveVectorTypeTemplate
		doing: [ :elementType :elements |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPrimitiveVectorType basicNew)
				elementType: elementType;
				elements: elements;
				initializeNonTraitType;
				yourself.
	].

	primitiveMatrixTypes := self createSystemProvidedTypeTemplate: #_PrimitiveMatrixTypeTemplate
		doing: [ :elementType :rowCount :columnCount |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPrimitiveMatrixType basicNew)
				elementType: elementType;
				rows: rowCount;
				columns: columnCount;
				initializeNonTraitType;
				yourself.
	].

	specificCompilerObjects := self createSystemProvidedTypeTemplate: #_SpecificCompilerObjectTypeTemplate
		doing: [ :behavior |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndSpecificCompilerObjectType basicNew)
				behavior: behavior;
				initializeNonTraitType;
				yourself.
	].
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializePrimitiveMatrixTypes [
	| baseType matrixTypeName matrixType |
	#(BooleanBit Int32 UInt32 Float32 Float64) do: [ :baseTypeName |
		baseType := self getBasicTypeNamed: baseTypeName.
		2 to: 4 do: [ :rowCount |
			2 to: 4 do: [ :columnCount |
				matrixTypeName := (baseTypeName , 'x' , rowCount asString , 'x' , columnCount asString).
				matrixType := baseType primitiveMatrixWithRows: rowCount columns: columnCount.
				matrixType name: matrixTypeName.
				basicTypes at: matrixTypeName put: matrixType.
			].
		].
	] 

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializePrimitiveVectorTypes [
	| baseType vectorTypeName vectorType |
	#(BooleanBit Int32 UInt32 Float32 Float64) do: [ :baseTypeName |
		baseType := self getBasicTypeNamed: baseTypeName.
		2 to: 4 do: [ :elementCount |
			vectorTypeName := (baseTypeName , 'x' , elementCount asString).
			vectorType := baseType primitiveVectorWithElements: elementCount.
			vectorType name: vectorTypeName.
			basicTypes at: vectorTypeName put: vectorType.
		].
	] 

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeTypeSystem [
	self
		initializeDerivedTypeCaches;
		initializeBasicTypes;
		initializePrimitiveVectorTypes;
		initializePrimitiveMatrixTypes;
		initializeArithmeticCoercionTable;
		initializeArithmeticConversionRules
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
		].
	
		bt initializeBasicTypeTrait
	].
]

{ #category : #'builder methods' }
TMbndCoreCompilationTarget >> lookupTypeWithName: typeName [
	^ basicTypes at: typeName ifAbsent: [ nil ]

]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> managedObjectModel [
	^ managedObjectModel ifNil: [managedObjectModel := self managedObjectModelClass for: self ]
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> managedObjectModelClass [
	^ MbndGenericManagedObjectModel
]

{ #category : #'instance creation' }
TMbndCoreCompilationTarget >> newCodeModuleGenerator [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> pointerFor: addressSpace to: baseType [
	^ pointerTypes getOrCreateInstanceWithArguments: { baseType . addressSpace }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> primitiveMatrixTypeFor: elementType rows: rowCount columns: columnCount [
	^ primitiveMatrixTypes getOrCreateInstanceWithArguments: { elementType . rowCount . columnCount }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> primitiveVectorTypeFor: elementType elements: vectorSize [
	^ primitiveVectorTypes getOrCreateInstanceWithArguments: { elementType . vectorSize }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> referenceFor: addressSpace to: baseType [
	^ referenceTypes getOrCreateInstanceWithArguments: { baseType . addressSpace }
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> setNativePrefixedStringLiteralType: aType [
	nativePrefixedStringLiteralType := aType.
	self literalStringType addConversionTo: nativePrefixedStringLiteralType rule: MbndLiteralStringToNativePrefixedStringConversionRule.
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> specificCompilerObjectTypeFor: aBehavior [
	^ specificCompilerObjects getOrCreateInstanceWithArguments: { aBehavior }
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> standardConcreteTypeForLiteralStringInScope: aScope [
	aScope isCompilationEvaluationScope ifTrue: [ ^ self compilerObjectType ].
	nativePrefixedStringLiteralType ifNotNil: [ ^ nativePrefixedStringLiteralType ].
	^ self uint8Type const pointer
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> tuple: elements [
	^ tupleTypes getOrCreateInstanceWithArguments: { elements }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> type: baseType withDecorations: decorations [
	decorations ifEmpty: [ ^ baseType ].
	^ decoratedTypes getOrCreateInstanceWithArguments: { baseType . decorations }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> variantUnionTypeWithComponents: components [
	| set |
	set := Set newFrom: components.
	^ variantUnions getOrCreateInstanceWithArguments: {set}
]
