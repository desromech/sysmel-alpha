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
		'gcClassVariableDataArrayTypes',
		'outputChannelTypes',
		'inputChannelTypes',
		'inputChannelImplementationType',
		'outputChannelImplementationType',
		'samplerImplementationType',
		'systemProvidedTypeTemplates',
		'defaultGCClassSuperClass',
		'temporaryReferenceTypes',
		'nativeBlockClosureTypes',
		'shaderModuleInfo',
		'shaderEntryPointInfo',
		'personalityFunction',
		'forbiddenExceptionHandlingFunction',
		'typeInformationNativeClass',
		'exceptionCatchBeginFunction',
		'exceptionCatchEndFunction',
		'nonLocalReturnRaiseFunction',
		'nonLocalReturnCatchFunction',
		'internalNonLocalReturnExceptionClass'
	],
	#traits : 'TMbndAbstractCompilationTarget',
	#classTraits : 'TMbndAbstractCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> addBasicCharTypeWithSize: size name: name [
	^ self addBasicType: (MbndPrimitiveCharacterCodeType basicNew
		name: name;
		instanceSize: size;
		instanceAlignment: size;
		signed: false;
		yourself)
]

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

{ #category : #initialization }
TMbndCoreCompilationTarget >> addGpuTextureTypeNamed: name sampled: sampled dimensions: dimensions layered: layered depth: depth multisampling: multisampling [
	| textureType |
	textureType := (self ensureBasicTypeIsLinkedToTheHierarchy: MbndTextureType basicNew)
		name: name;
		sampled: sampled;
		dimensions: dimensions;
		depth: depth;
		multisampling: multisampling;
		layered: layered;
		initializeNonTraitType;
		yourself.
	basicTypes at: name put: textureType.
	^ textureType

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
TMbndCoreCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
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
	
	"Promote characters into integers."
	bestLeftType isPrimitiveCharacterCodeType ifTrue: [
		bestLeftType := bestLeftType asIntegerType
	].
	bestRightType isPrimitiveCharacterCodeType ifTrue: [
		bestRightType := bestRightType asIntegerType
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

	"Promote to dynobject type."
	(leftType isGarbageCollectedType or: [ rightType isGarbageCollectedType ]) ifTrue: [ 
		(leftType isGarbageCollectedType and: [ rightType isGarbageCollectedType ]) ifTrue: [ 
			(leftType isSubtypeOf: rightType) ifTrue: [ ^ rightType ].
			(rightType isSubtypeOf: leftType) ifTrue: [ ^ leftType ].
			"TODO: Find a common ancestor"
			self halt.
		].
	
		^ self dynamicObjectType
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

	leftType isUndefinedType ifTrue: [ ^ rightType coercedConditionallyWithUndefinedType ].
	rightType isUndefinedType ifTrue: [ ^ leftType coercedConditionallyWithUndefinedType ].
	
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
TMbndCoreCompilationTarget >> createSystemProvidedTypeTemplate: templateName argumentNames: argumentNames doing: aBlock [
	| template |
	template := MbndSystemProvidedTypeTemplate new
		name: templateName;
		argumentNames: argumentNames;
		mainDefinitionConstructionBlock: aBlock;
		compilationTarget: self;
		yourself.
	self systemProvidedTypeTemplates add: template.
	^ template
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> defaultGCClassSuperClass [
	^ defaultGCClassSuperClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> defaultGCClassSuperClass: aGCClassType [
	defaultGCClassSuperClass := aGCClassType
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

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCatchBeginFunction [
	^ exceptionCatchBeginFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCatchBeginFunction: anObject [
	exceptionCatchBeginFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCatchEndFunction [
	^ exceptionCatchEndFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCatchEndFunction: anObject [
	exceptionCatchEndFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> forbiddenExceptionHandlingFunction [
	^ forbiddenExceptionHandlingFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> forbiddenExceptionHandlingFunction: aFunction [
	forbiddenExceptionHandlingFunction := aFunction
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic [
	^ functionTypes getOrCreateInstanceWithArguments: { argumentTypes . returnType . callingConvention . cvariadic}
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> gcClassVariableDataArrayOf: elementType [
	^ gcClassVariableDataArrayTypes getOrCreateInstanceWithArguments: { elementType }
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> gcInitializationPriority [
	^ -1000
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> gcModuleRootRegistrationPriority [
	^ self gcInitializationPriority + 1
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
	| char8Type char16Type char32Type int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	char8Type := self char8Type.
	char16Type := self char16Type.
	char32Type := self char32Type.

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
	char8Type addConversionTo: uint8Type rule: MbndBitCastTypeConversionRule.
	char16Type addConversionTo: uint16Type rule: MbndBitCastTypeConversionRule.
	char32Type addConversionTo: uint32Type rule: MbndBitCastTypeConversionRule.
	uint8Type addConversionTo: char8Type rule: MbndBitCastTypeConversionRule.
	uint16Type addConversionTo: char16Type rule: MbndBitCastTypeConversionRule.
	uint32Type addConversionTo: char32Type rule: MbndBitCastTypeConversionRule.
	
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
		addBasicType: (MbndPrimitiveBooleanType basicNew name: #Boolean8; yourself);
		addBasicCharTypeWithSize: 1 name: #Char8;
		addBasicCharTypeWithSize: 2 name: #Char16;
		addBasicCharTypeWithSize: 4 name: #Char32;

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

	self systemProvidedTypeTemplates do: [ :template |
		basicTypes at: template name put: template
	]
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeDerivedTypeCaches [
	pointerTypes := self createSystemProvidedTypeTemplate: #_PointerTypeTemplate
		argumentNames: #(BaseType AddressSpace)
		doing: [ :baseType :addressSpace |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPointerType basicNew)
				addressSpace: addressSpace;
				baseType: baseType;
				initializeNonTraitType;
				yourself.
		].

	referenceTypes := self createSystemProvidedTypeTemplate: #_ReferenceTypeTemplate
		argumentNames: #(BaseType AddressSpace)
		doing: [ :baseType :addressSpace |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndReferenceType basicNew)
				addressSpace: addressSpace;
				baseType: baseType;
				initializeNonTraitType;
				yourself.
	].

	temporaryReferenceTypes := self createSystemProvidedTypeTemplate: #_TemporaryReferenceTypeTemplate
		argumentNames: #(BaseType AddressSpace)
		doing: [ :baseType :addressSpace |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndTemporaryReferenceType basicNew)
				addressSpace: addressSpace;
				baseType: baseType;
				initializeNonTraitType;
				yourself.
	].

	functionTypes := self createSystemProvidedTypeTemplate: #_FunctionTypeTemplate
		argumentNames: #(ArgumentTypes ReturnType CallingConvention IsCVariadic)
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
		argumentNames: #(FunctionType)
		doing: [ :functionType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndAbstractBlockClosureType basicNew)
				functionType: functionType;
				initializeNonTraitType;
				yourself.
	].

	nativeBlockClosureTypes := self createSystemProvidedTypeTemplate: #_NativeBlockClosureTypeTemplate
		argumentNames: #(FunctionType)
		doing: [ :functionType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndNativeBlockClosureType basicNew)
				functionType: functionType;
				initializeNonTraitType;
				yourself.
	].

	decoratedTypes := self createSystemProvidedTypeTemplate: #_DecoratedTypeTemplate
		argumentNames: #(BaseType Decorations)
		doing: [ :baseType :decorations |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndDecoratedType basicNew)
				baseType: baseType;
				decorations: decorations;
				initializeNonTraitType;
				yourself.
	].
	variantUnions := self createSystemProvidedTypeTemplate: #_VariantUnionTypeTemplate
		argumentNames: #(Components)
		doing: [ :components |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndVariantUnionType basicNew)
				components: components;
				initializeNonTraitType;
				yourself.
	].

	arrayTypes := self createSystemProvidedTypeTemplate: #_BasicArrayTypeTemplate
		argumentNames: #(ElementType ElementCount)
		doing: [ :elementType :elementCount |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndArrayType basicNew)
				elementType: elementType;
				elements: elementCount;
				initializeNonTraitType;
				yourself.
	].

	gcClassVariableDataArrayTypes := self createSystemProvidedTypeTemplate: #_GCClassVariableDataArrayTypeTemplate
		argumentNames: #(ElementType)
		doing: [ :elementType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndGCClassVariableDataArrayType basicNew)
				elementType: elementType;
				initializeNonTraitType;
				yourself.
	].

	tupleTypes := self createSystemProvidedTypeTemplate: #_TupleTypeTemplate
		argumentNames: #(Elements)
		doing: [ :elements |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndTupleType basicNew)
				elements: elements;
				initializeNonTraitType;
				yourself.
	].

	associationTypes := self createSystemProvidedTypeTemplate: #_AssociationTypeTemplate
		argumentNames: #(KeyType ValueType)
		doing: [ :keyType :valueType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndAssociationType basicNew)
				keyType: keyType;
				valueType: valueType;
				initializeNonTraitType;
				yourself.
	].

	primitiveVectorTypes := self createSystemProvidedTypeTemplate: #_PrimitiveVectorTypeTemplate
		argumentNames: #(ElementType Elements)
		doing: [ :elementType :elements |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPrimitiveVectorType basicNew)
				elementType: elementType;
				elements: elements;
				initializeNonTraitType;
				yourself.
	].

	primitiveMatrixTypes := self createSystemProvidedTypeTemplate: #_PrimitiveMatrixTypeTemplate
		argumentNames: #(ElementType RowCount ColumnCount)
		doing: [ :elementType :rowCount :columnCount |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndPrimitiveMatrixType basicNew)
				elementType: elementType;
				rows: rowCount;
				columns: columnCount;
				initializeNonTraitType;
				yourself.
	].

	specificCompilerObjects := self createSystemProvidedTypeTemplate: #_SpecificCompilerObjectTypeTemplate
		argumentNames: #(Behavior)
		doing: [ :behavior |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndSpecificCompilerObjectType basicNew)
				behavior: behavior;
				initializeNonTraitType;
				yourself.
	].

	inputChannelTypes := self createSystemProvidedTypeTemplate: #_InputChannelTypeTemplate
		argumentNames: #(MessageType)
		doing: [ :messageType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndInputChannelType basicNew)
				messageType: messageType;
				initializeNonTraitType;
				yourself.
	].

	outputChannelTypes := self createSystemProvidedTypeTemplate: #_OutputChannelTypeTemplate
		argumentNames: #(MessageType)
		doing: [ :messageType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndOutputChannelType basicNew)
				messageType: messageType;
				initializeNonTraitType;
				yourself.
	].

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeGpuTypes [
	self 
		addGpuTextureTypeNamed: #GPUTexture1D sampled: true dimensions: 1 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture1DArray sampled: true dimensions: 1 layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture2D sampled: true dimensions: 2 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture2DArray sampled: true dimensions: 2 layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTextureCube sampled: true dimensions: #cube layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTextureCubeArray sampled: true dimensions: #cube layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture3D sampled: true dimensions: 3 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture3DArray sampled: true dimensions: 3 layered: false depth: false multisampling: false;
		
		addGpuTextureTypeNamed: #GPUDepthTexture2D sampled: true dimensions: 2 layered: false depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTexture2DArray sampled: true dimensions: 2 layered: true depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTextureCube sampled: true dimensions: #cube layered: false depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTextureCubeArray sampled: true dimensions: #cube layered: true depth: true multisampling: false.
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializePrimitiveMatrixTypes [
	| baseType matrixTypeName matrixType |
	#(Boolean8 Int32 UInt32 Float32 Float64) do: [ :baseTypeName |
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
	#(Boolean8 Int8 UInt8 Int16 UInt16 Int32 UInt32 Float32 Float64) do: [ :baseTypeName |
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
		initializeGpuTypes;
		initializeArithmeticCoercionTable;
		initializeArithmeticConversionRules
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> inputChannelFor: messageType specialSemantics: specialSemantics [
	^ inputChannelTypes getOrCreateInstanceWithArguments: { messageType . specialSemantics }
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> inputChannelImplementationType [
	^ inputChannelImplementationType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> inputChannelImplementationType: anObject [
	inputChannelImplementationType := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> internalNonLocalReturnExceptionClass [
	<compileTime>
	^ internalNonLocalReturnExceptionClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> internalNonLocalReturnExceptionClass: aClass [
	<compileTime>
	internalNonLocalReturnExceptionClass := aClass
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> landingPadSelectorRegisterIndex [
	^ 1
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> landingPadStructurePointerRegisterIndex [
	^ 0
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

	self basicType type supertype: self behaviorType
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

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> nativeBlockClosureTypeWithSignature: functionType [
	^ nativeBlockClosureTypes getOrCreateInstanceWithArguments: { functionType }
]

{ #category : #'instance creation' }
TMbndCoreCompilationTarget >> newCodeModuleGenerator [
	self explicitRequirement
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nonLocalReturnCatchFunction [
	^ nonLocalReturnCatchFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nonLocalReturnCatchFunction: anObject [
	nonLocalReturnCatchFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nonLocalReturnRaiseFunction [
	^ nonLocalReturnRaiseFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nonLocalReturnRaiseFunction: anObject [
	nonLocalReturnRaiseFunction := anObject
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> outputChannelFor: messageType specialSemantics: specialSemantics [
	^ outputChannelTypes getOrCreateInstanceWithArguments: { messageType . specialSemantics }
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> outputChannelImplementationType [
	^ outputChannelImplementationType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> outputChannelImplementationType: anObject [
	outputChannelImplementationType := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> personalityFunction [
	^ personalityFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> personalityFunction: aPersonalityFunction [
	personalityFunction := aPersonalityFunction
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

{ #category : #accessing }
TMbndCoreCompilationTarget >> samplerImplementationType [
	^ samplerImplementationType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> samplerImplementationType: aType [
	samplerImplementationType := aType
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> setNativePrefixedStringLiteralType: aType [
	nativePrefixedStringLiteralType := aType.
	self literalStringType addConversionTo: nativePrefixedStringLiteralType rule: MbndLiteralStringToNativePrefixedStringConversionRule.
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> shaderEntryPointInfo [
	^ shaderEntryPointInfo
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> shaderEntryPointInfo: anObject [
	shaderEntryPointInfo := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> shaderModuleInfo [
	^ shaderModuleInfo
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> shaderModuleInfo: anObject [
	shaderModuleInfo := anObject
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> specificCompilerObjectTypeFor: aBehavior [
	^ specificCompilerObjects getOrCreateInstanceWithArguments: { aBehavior }
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> standardConcreteTypeForLiteralStringInScope: aScope [
	aScope isCompilationEvaluationScope ifTrue: [ ^ self compilerObjectType ].
	dynamicObjectType ifNotNil: [ 
		aScope defaultVariableType == dynamicObjectType ifTrue: [ ^ self managedObjectModel stringClass ]
	].

	nativePrefixedStringLiteralType ifNotNil: [ ^ nativePrefixedStringLiteralType ].
	^ self char8Type const pointer
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> standardConcreteTypeForSymbolInScope: aScope [
	aScope isCompilationEvaluationScope ifTrue: [ ^ self compilerObjectType ].
	self managedObjectModel symbolClass ifNotNil: [ ^ self managedObjectModel symbolClass ].
	self error: 'Unsupported symbols at this context.'
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> systemProvidedTypeTemplates [
	^ systemProvidedTypeTemplates ifNil: [ systemProvidedTypeTemplates := OrderedCollection new ]
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> temporaryReferenceFor: addressSpace to: baseType [
	^ temporaryReferenceTypes getOrCreateInstanceWithArguments: { baseType . addressSpace }
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

{ #category : #accessing }
TMbndCoreCompilationTarget >> typeInformationNativeClass [
	^ typeInformationNativeClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> typeInformationNativeClass: anObject [
	typeInformationNativeClass := anObject
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> variantUnionTypeWithComponents: components [
	| set |
	set := Set newFrom: components.
	^ variantUnions getOrCreateInstanceWithArguments: {set}
]
