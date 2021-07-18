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
		'associationTypes',
		'primitiveVectorTypes',
		'primitiveMatrixTypes',
		'dynamicObjectType',
		'managedObjectModel',
		'outputChannelTypes',
		'inputChannelTypes',
		'inputChannelImplementationType',
		'outputChannelImplementationType',
		'systemProvidedTypeTemplates',
		'defaultGCClassSuperClass',
		'temporaryReferenceTypes',
		'nativeBlockClosureTypes',
		'shaderModuleInfo',
		'shaderEntryPointInfo',
		'personalityFunction',
		'forbiddenExceptionHandlingFunction',
		'typeInformationClass',
		'moduleNamespaceInformationClass',
		'moduleInformationClass',
		'extensionMacroMessageClass',
		'extensionOverloadedMethodClass',
		'extensionMethodClass',
		'exceptionCatchBeginFunction',
		'exceptionCatchEndFunction',
		'nonLocalReturnRaiseFunction',
		'nonLocalReturnCatchFunction',
		'internalNonLocalReturnExceptionClass',
		'typeSystemInitialized',
		'simultaneousTypeConcepts',
		'patternMatchingFailureRaiseFunction',
		'variantUnexpectedComponentRaiseFunction',
		'nativeComputeShaderIOInterface',
		'nativeVertexShaderIOInterface',
		'nativeFragmentShaderIOInterface',
		'nativeGeometryShaderIOInterface',
		'nativeTessellationControlShaderIOInterface',
		'nativeTessellationEvaluationShaderIOInterface',
		'arraySlicesTypes',
		'indexOutOfBoundsRaiseFunction',
		'sampleTextureImplicitLodFunction',
		'sampleTextureExplicitLodFunction',
		'sampleTextureExplicitDerivativesFunction',
		'sysmelAtExitFunction',
		'exceptionContextType',
		'exceptionSetjmpFunction',
		'exceptionLongjmpFunction',
		'exceptionContextBeginFunction',
		'exceptionContextEndFunction',
		'exceptionCleanUpEndFunction',
		'exceptionCatchTestDynamicTypeFunction',
		'exceptionRethrowFunction',
		'functionInformationClass',
		'macroMessageMethodInformationClass',
		'messageMethodInformationClass'
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
		addFlag: #coreBasicType;
		yourself.
	basicTypes at: name put: textureType.
	^ textureType

]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> arrayOf: elementType elements: elementCount [
	^ arrayTypes getOrCreateInstanceWithArguments: { elementType . elementCount }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> arraySliceOf: elementType [
	^ arraySlicesTypes getOrCreateInstanceWithArguments: { elementType }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> associationKey: keyType value: valueType [
	(keyType isLiteralValueType or: [ valueType isLiteralValueType ]) ifTrue: [ ^ self literalAssociationType ].
	^ associationTypes getOrCreateInstanceWithArguments: { keyType . valueType }
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> basicTypeCategory [
	^ 'BasicType'
]

{ #category : #'builder methods' }
TMbndCoreCompilationTarget >> basicTypes [
	^ basicTypes asArray
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
	leftValueType == rightValueType ifTrue: [ ^ leftValueType coercedAsConditionalResult ].

	^ ((self computeArithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode inScope: aScope)
		ifNil: [self voidType]) coercedAsConditionalResult.
	
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

{ #category : #'constructor priorities' }
TMbndCoreCompilationTarget >> coreRuntimeInitializationPriority [
	^ self normalConstructorPriority - 200
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> createNamedType: name ofKind: typeKindClass [
	^ self createNamedType: name ofKind: typeKindClass inModule: nil
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> createNamedType: name ofKind: typeKindClass inModule: definitionModule [
	| result |
	result := (self ensureBasicTypeIsLinkedToTheHierarchy: (typeKindClass basicNew
		definitionModule: definitionModule))
		name: name;
		initializeNonTraitType;
		yourself.
	definitionModule ifNotNil: [ 
		definitionModule recordCreatedType: result
	].
	^ result
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

{ #category : #serialization }
TMbndCoreCompilationTarget >> encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder [
	^ Array streamContents: [:out |
		#(
			"Embedded shaders"
			shaderEntryPointInfo shaderModuleInfo
			
			"Shader CPU simulation"
			nativeComputeShaderIOInterface nativeVertexShaderIOInterface nativeFragmentShaderIOInterface 			nativeGeometryShaderIOInterface nativeTessellationControlShaderIOInterface
			nativeTessellationEvaluationShaderIOInterface
			sampleTextureImplicitLodFunction sampleTextureExplicitLodFunction sampleTextureExplicitDerivativesFunction
			
			"RTTI"
			typeInformationClass
			moduleNamespaceInformationClass
			moduleInformationClass
			
			functionInformationClass
			macroMessageMethodInformationClass
			messageMethodInformationClass
			
			extensionMacroMessageClass
			extensionOverloadedMethodClass
			extensionMethodClass
			
			"Static constructors/destructors"
			sysmelAtExitFunction
			
			"EH"
			exceptionContextType
			#exceptionCleanUpEndFunction
			#exceptionContextBeginFunction
			#exceptionContextEndFunction
			exceptionSetjmpFunction
			exceptionLongjmpFunction

			exceptionCatchTestDynamicTypeFunction
			exceptionCatchBeginFunction
			exceptionCatchEndFunction
			exceptionRethrowFunction
			forbiddenExceptionHandlingFunction
			internalNonLocalReturnExceptionClass
			personalityFunction
			nonLocalReturnCatchFunction
			nonLocalReturnRaiseFunction
			patternMatchingFailureRaiseFunction
			variantUnexpectedComponentRaiseFunction
			indexOutOfBoundsRaiseFunction
			
			) do: [ :selector |
			out nextPut: selector; nextPut: ((self perform: selector) encodeGraphForMessagePackWith: graphEncoder)
		].
	
		out nextPut: #managedObjectModel; nextPut: (managedObjectModel encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder)
	].

]

{ #category : #serialization }
TMbndCoreCompilationTarget >> encodeGraphForMessagePackWith: graphEncoder [
	^ graphEncoder encodeObject: self type: #CompilationTarget fields: [#()].
]

{ #category : #'basic types' }
TMbndCoreCompilationTarget >> ensureBasicTypeIsLinkedToTheHierarchy: basicType [
	basicType module ifNil: [ 
		basicType
			category: self basicTypeCategory;
			definitionModule: coreDefinitionsModule.
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
		definitionModule: type module;
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
TMbndCoreCompilationTarget >> exceptionCatchTestDynamicTypeFunction [
	^ exceptionCatchTestDynamicTypeFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCatchTestDynamicTypeFunction: aFunction [
	exceptionCatchTestDynamicTypeFunction := aFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCleanUpEndFunction [
	^ exceptionCleanUpEndFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionCleanUpEndFunction: anObject [
	exceptionCleanUpEndFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextBeginFunction [
	^ exceptionContextBeginFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextBeginFunction: anObject [
	exceptionContextBeginFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextEndFunction [
	^ exceptionContextEndFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextEndFunction: anObject [
	exceptionContextEndFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextType [
	^ exceptionContextType
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionContextType: anObject [
	exceptionContextType := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionLongjmpFunction [
	^ exceptionLongjmpFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionLongjmpFunction: anObject [
	exceptionLongjmpFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionRethrowFunction [
	^ exceptionRethrowFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionRethrowFunction: aFunction [
	exceptionRethrowFunction := aFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionSetjmpFunction [
	^ exceptionSetjmpFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> exceptionSetjmpFunction: anObject [
	exceptionSetjmpFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionMacroMessageClass [
	^ extensionMacroMessageClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionMacroMessageClass: aClass [
	extensionMacroMessageClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionMethodClass [
	^ extensionMethodClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionMethodClass: aClass [
	extensionMethodClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionOverloadedMethodClass [
	^ extensionOverloadedMethodClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> extensionOverloadedMethodClass: aClass [
	extensionOverloadedMethodClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> forbiddenExceptionHandlingFunction [
	^ forbiddenExceptionHandlingFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> forbiddenExceptionHandlingFunction: aFunction [
	forbiddenExceptionHandlingFunction := aFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> functionInformationClass [
	^ functionInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> functionInformationClass: aClass [
	functionInformationClass := aClass
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic [
	^ functionTypes getOrCreateInstanceWithArguments: { argumentTypes . returnType . callingConvention . cvariadic}
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> getBasicTypeNamed: typeName [
	^ basicTypes at: typeName
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> identityHashForSymbol: symbol [
	^ self managedObjectModel identityHashForSymbol: symbol
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> identityHashForSymbolInDictionary: symbol [
	^ (self managedObjectModel identityHashForSymbol: symbol) & (self managedObjectModel identityHashFieldBitMask)
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> indexOutOfBoundsRaiseFunction [
	^ indexOutOfBoundsRaiseFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> indexOutOfBoundsRaiseFunction: aFunction [
	^ indexOutOfBoundsRaiseFunction := aFunction
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeAdditionalConversionRules [
	self literalStringType
		addConversionTo: self char8Type const arraySlice rule: MbndLiteralStringToArraySliceConstantConversionRule;
		addConversionTo: self char16Type const arraySlice rule: MbndLiteralStringToArraySliceConstantConversionRule;
		addConversionTo: self char32Type const arraySlice rule: MbndLiteralStringToArraySliceConstantConversionRule;
		addConversionTo: self uint8Type const arraySlice rule: MbndLiteralStringToArraySliceConstantConversionRule.
	self literalSymbolType
		addConversionTo: self char8Type const arraySlice rule: MbndLiteralStringToArraySliceConstantConversionRule
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
		(Int64 Float32 Float64)
		(UInt64 Float32 Float64)

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
	| booleanType char8Type char16Type char32Type int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	booleanType := self booleanType.
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
	{int8Type . int16Type . int32Type . int64Type} do: [:each |
		each addImplicitConversionToAll: {uint8Type . uint16Type . uint32Type . uint64Type}
			rule: MbndPositiveLiteralToUnsignedTypeConversionRule
	].

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
	{int64Type . uint64Type .
	char32Type . int32Type . uint32Type .
	char16Type . int16Type . uint16Type} do: [ :each |
		each addExplicitConversionToAll: {char8Type . int8Type . uint8Type} rule: MbndTruncateTypeConversionRule.
	].
	{int64Type . uint64Type .
	char32Type . int32Type . uint32Type} do: [ :each |
		each addExplicitConversionToAll: {char16Type . int16Type . uint16Type} rule: MbndTruncateTypeConversionRule.
	].
	{int64Type . uint64Type} do: [ :each |
		each addExplicitConversionToAll: {char32Type . int32Type . uint32Type} rule: MbndTruncateTypeConversionRule.
	].
	
	"Sign extension"
	{int8Type . int16Type . int32Type} do: [:each |
		each addConversionToAll: {int64Type . uint64Type}
			rule: MbndSignExtensionTypeConversionRule
	].
	{int8Type . int16Type} do: [:each |
		each addConversionToAll: {int32Type . uint32Type . int64Type . uint64Type}
			rule: MbndSignExtensionTypeConversionRule
	].
	int8Type addConversionToAll:
		{int16Type . uint16Type . int32Type . uint32Type . int64Type . uint64Type}
		rule: MbndSignExtensionTypeConversionRule.
	
	"Zero extension"
	{char8Type . uint8Type . char16Type . uint16Type . char32Type . uint32Type} do: [:each | each 
		addConversionToAll: {int64Type . uint64Type}
			rule: MbndZeroExtensionTypeConversionRule
	].
	{char8Type . uint8Type . char16Type . uint16Type} do: [:each |
		each addConversionToAll: {char32Type . int32Type . uint32Type}
			rule: MbndZeroExtensionTypeConversionRule.
	].
	{char8Type . uint8Type} do: [:each | each addConversionToAll:
		{char16Type . int16Type . uint16Type}
		rule: MbndZeroExtensionTypeConversionRule.
	].


	"Int -> FP"
	{
	char8Type . char16Type . char32Type .
	int8Type . uint8Type .
	int16Type . uint16Type .
	int32Type . uint32Type .
	int64Type . uint64Type} do: [:each |
		each addConversionToAll: {float16Type . float32Type . float64Type}
			rule: MbndIntegerToFloatingPointTypeConversionRule
	].

	"FP -> Int"
	{float16Type . float32Type . float64Type} do: [:each |
		each addExplicitConversionToAll: {int8Type . uint8Type .
			int16Type . uint16Type .
			int32Type . uint32Type .
			int64Type . uint64Type}
		rule: MbndFloatingPointToIntegerTypeConversionRule
	].

	"FP -> FP"
	float16Type addConversionToAll: {float32Type . float64Type} rule: MbndFloatingPointSizeTypeConversionRule.

	float32Type addConversionTo: float64Type rule: MbndFloatingPointSizeTypeConversionRule.
	float32Type addExplicitConversionTo: float16Type rule: MbndFloatingPointSizeTypeConversionRule.

	float64Type addExplicitConversionToAll: {float16Type . float32Type} rule: MbndFloatingPointSizeTypeConversionRule.


	"Bool -> Int"
	booleanType addExplicitConversionToAll: {char8Type . char16Type . char32Type . uint8Type . int8Type . uint16Type . int16Type .
		uint32Type . int32Type . uint64Type . int64Type}
		rule: MbndZeroExtensionTypeConversionRule.
		
	{char8Type . char16Type . char32Type . uint8Type . int8Type . uint16Type . int16Type .
		uint32Type . int32Type . uint64Type . int64Type .
		float16Type . float32Type . float64Type} do: [:each |
		each addExplicitConversionTo: booleanType rule: MbndNumberToBooleanConversionRule
	].
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializeBasicTypes [
	| basicType typesToInitialize | 
	basicTypes := Dictionary new.
	MbndBasicType withAllSubclassesDo: [ :sc |
		sc typeName ifNotNil: [
			basicType := sc basicNew
				category: self basicTypeCategory;
				definitionModule: coreDefinitionsModule.
			basicTypes at: sc typeName put: basicType.
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
		bt type initializeNonTraitType.
		bt addFlag: #coreBasicType.
	].

	basicTypes valuesDo: [ :each | self assert: each isCoreBasicType ].

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
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndGCBlockClosureType basicNew)
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

	simultaneousTypeConcepts := self createSystemProvidedTypeTemplate: #_SimultaneousTypeConceptsTemplate
		argumentNames: #(Components)
		doing: [ :components |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndSimultaneousTypeConcept basicNew)
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

	arraySlicesTypes := self createSystemProvidedTypeTemplate: #_ArraySliceTypeTemplate
		argumentNames: #(ElementType)
		doing: [ :elementType |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndArraySliceType basicNew)
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
		argumentNames: #(MessageType SpecialSemantics)
		doing: [ :messageType :specialSemantics |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndInputChannelType basicNew)
				messageType: messageType;
				specialSemantics: specialSemantics;
				initializeNonTraitType;
				yourself.
	].

	outputChannelTypes := self createSystemProvidedTypeTemplate: #_OutputChannelTypeTemplate
		argumentNames: #(MessageType SpecialSemantics)
		doing: [ :messageType :specialSemantics |
			(self ensureBasicTypeIsLinkedToTheHierarchy: MbndOutputChannelType basicNew)
				messageType: messageType;
				specialSemantics: specialSemantics;
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
		addGpuTextureTypeNamed: #GPUTexture2DMS sampled: true dimensions: 2 layered: false depth: false multisampling: true;
		addGpuTextureTypeNamed: #GPUTexture2DMSArray sampled: true dimensions: 2 layered: true depth: false multisampling: true;
		addGpuTextureTypeNamed: #GPUTextureCube sampled: true dimensions: #cube layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTextureCubeArray sampled: true dimensions: #cube layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture3D sampled: true dimensions: 3 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUTexture3DArray sampled: true dimensions: 3 layered: false depth: false multisampling: false;
		
		addGpuTextureTypeNamed: #GPUDepthTexture2D sampled: true dimensions: 2 layered: false depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTexture2DArray sampled: true dimensions: 2 layered: true depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTexture2DMS sampled: true dimensions: 2 layered: false depth: true multisampling: true;
		addGpuTextureTypeNamed: #GPUDepthTexture2DMSArray sampled: true dimensions: 2 layered: true depth: true multisampling: true;
		addGpuTextureTypeNamed: #GPUDepthTextureCube sampled: true dimensions: #cube layered: false depth: true multisampling: false;
		addGpuTextureTypeNamed: #GPUDepthTextureCubeArray sampled: true dimensions: #cube layered: true depth: true multisampling: false.
		
	
		"addGpuTextureTypeNamed: #GPUImage1D sampled: false dimensions: 1 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage1DArray sampled: false dimensions: 1 layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage2D sampled: false dimensions: 2 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage2DArray sampled: false dimensions: 2 layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage2DMS sampled: false dimensions: 2 layered: false depth: false multisampling: true;
		addGpuTextureTypeNamed: #GPUImage2DMSArray sampled: false dimensions: 2 layered: true depth: false multisampling: true;
		addGpuTextureTypeNamed: #GPUImageCube sampled: false dimensions: #cube layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImageCubeArray sampled: false dimensions: #cube layered: true depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage3D sampled: false dimensions: 3 layered: false depth: false multisampling: false;
		addGpuTextureTypeNamed: #GPUImage3DArray sampled: false dimensions: 3 layered: false depth: false multisampling: false"
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializePrimitiveMatrixTypes [
	| baseType matrixTypeName matrixType |
	#(Boolean8 Int32 UInt32 Int64 UInt64 Float32 Float64) do: [ :baseTypeName |
		baseType := self getBasicTypeNamed: baseTypeName.
		2 to: 4 do: [ :rowCount |
			2 to: 4 do: [ :columnCount |
				matrixTypeName := (baseTypeName , 'x' , rowCount asString , 'x' , columnCount asString).
				matrixType := baseType primitiveMatrixWithRows: rowCount columns: columnCount.
				matrixType name: matrixTypeName.
				matrixType addFlag: #coreBasicType.
				basicTypes at: matrixTypeName put: matrixType.
			].
		].
	] 

]

{ #category : #initialization }
TMbndCoreCompilationTarget >> initializePrimitiveVectorTypes [
	| baseType vectorTypeName vectorType |
	#(Boolean8 Int8 UInt8 Int16 UInt16 Int32 UInt32 Int64 UInt64 Float32 Float64) do: [ :baseTypeName |
		baseType := self getBasicTypeNamed: baseTypeName.
		2 to: 4 do: [ :elementCount |
			vectorTypeName := (baseTypeName , 'x' , elementCount asString).
			vectorType := baseType primitiveVectorWithElements: elementCount.
			vectorType name: vectorTypeName.
			vectorType addFlag: #coreBasicType.
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
		initializeArithmeticConversionRules.
	typeSystemInitialized := true.
	self initializeAdditionalConversionRules
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

{ #category : #initialization }
TMbndCoreCompilationTarget >> isTheTypeSystemInitialized [
	^ typeSystemInitialized ifNil: [ typeSystemInitialized := false ]
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> landingPadSelectorRegisterIndex [
	^ 1
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> landingPadStackPointerRegisterIndex [
	^ 0
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

{ #category : #accessing }
TMbndCoreCompilationTarget >> macroMessageMethodInformationClass [
	^ macroMessageMethodInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> macroMessageMethodInformationClass: aClass [
	macroMessageMethodInformationClass := aClass
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> managedObjectModel [
	^ managedObjectModel ifNil: [managedObjectModel := self managedObjectModelClass for: self ]
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> managedObjectModelClass [
	^ MbndGenericManagedObjectModel
]

{ #category : #serialization }
TMbndCoreCompilationTarget >> materializeBootstrapDefinedObjectWithGraphDecoder: graphDecoder withFields: encodedFields [
	encodedFields keysAndValuesDo: [ :key :value |
		key ~~ #managedObjectModel ifTrue: [
			| selector |
			selector := (key , ':') asSymbol.
			self perform: selector with: value.
		].
	].

	encodedFields at: #managedObjectModel ifPresent: [ :objects |
		self managedObjectModel materializeBootstrapDefinedObjectWithGraphDecoder: graphDecoder withFields: (Dictionary newFromPairs: objects)
	].
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> messageMethodInformationClass [
	^ messageMethodInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> messageMethodInformationClass: aClass [
	messageMethodInformationClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> moduleInformationClass [
	^ moduleInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> moduleInformationClass: aClass [
	moduleInformationClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> moduleNamespaceInformationClass [
	^ moduleNamespaceInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> moduleNamespaceInformationClass: aClass [
	moduleNamespaceInformationClass := aClass
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> nativeBlockClosureTypeWithSignature: functionType [
	^ nativeBlockClosureTypes getOrCreateInstanceWithArguments: { functionType }
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeComputeShaderIOInterface [
	^ nativeComputeShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeComputeShaderIOInterface: anObject [
	nativeComputeShaderIOInterface := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeFragmentShaderIOInterface [
	^ nativeFragmentShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeFragmentShaderIOInterface: anObject [
	nativeFragmentShaderIOInterface := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeGeometryShaderIOInterface [
	^ nativeGeometryShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeGeometryShaderIOInterface: anObject [
	nativeGeometryShaderIOInterface := anObject
]

{ #category : #'as yet unclassified' }
TMbndCoreCompilationTarget >> nativeShaderIOInterfaceWithSemantics: specialSemantics [
	specialSemantics = #vertex ifTrue: [ ^ nativeVertexShaderIOInterface ].
	specialSemantics = #fragment ifTrue: [ ^ nativeFragmentShaderIOInterface ].
	specialSemantics = #compute ifTrue: [ ^ nativeComputeShaderIOInterface ].
	specialSemantics = #geometry ifTrue: [ ^ nativeGeometryShaderIOInterface ].
	specialSemantics = #tessellationControl ifTrue: [ ^ nativeTessellationControlShaderIOInterface ].
	specialSemantics = #tessellationEvaluation ifTrue: [ ^ nativeTessellationEvaluationShaderIOInterface ].
	^ nil
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeTessellationControlShaderIOInterface [
	^ nativeTessellationControlShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeTessellationControlShaderIOInterface: anObject [
	nativeTessellationControlShaderIOInterface := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeTessellationEvaluationShaderIOInterface [
	^ nativeTessellationEvaluationShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeTessellationEvaluationShaderIOInterface: anObject [
	nativeTessellationEvaluationShaderIOInterface := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeVertexShaderIOInterface [
	^ nativeVertexShaderIOInterface
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> nativeVertexShaderIOInterface: anObject [
	nativeVertexShaderIOInterface := anObject
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

{ #category : #'constructor priorities' }
TMbndCoreCompilationTarget >> normalConstructorPriority [
	^ 16rffff
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
TMbndCoreCompilationTarget >> patternMatchingFailureRaiseFunction [
	^ patternMatchingFailureRaiseFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> patternMatchingFailureRaiseFunction: aFunction [
	patternMatchingFailureRaiseFunction := aFunction
]

{ #category : #'convenience type accessors' }
TMbndCoreCompilationTarget >> patternMatchingPatternType [
	^ self getBasicTypeNamed: MbndPatternMatchingPatternType typeName
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

{ #category : #'constructor priorities' }
TMbndCoreCompilationTarget >> reflectionConstructorPriority [
	^ self normalConstructorPriority - 100
]

{ #category : #'constructor priorities' }
TMbndCoreCompilationTarget >> runtimeInitializationPriority [
	^ self normalConstructorPriority - 200
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureExplicitDerivativesFunction [
	^ sampleTextureExplicitDerivativesFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureExplicitDerivativesFunction: anObject [
	sampleTextureExplicitDerivativesFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureExplicitLodFunction [
	^ sampleTextureExplicitLodFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureExplicitLodFunction: anObject [
	sampleTextureExplicitLodFunction := anObject
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureImplicitLodFunction [
	^ sampleTextureImplicitLodFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sampleTextureImplicitLodFunction: anObject [
	sampleTextureImplicitLodFunction := anObject
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
TMbndCoreCompilationTarget >> simultanousTypeConcepts: components [
	| set |
	set := Set newFrom: components.
	^ simultaneousTypeConcepts getOrCreateInstanceWithArguments: {set}
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

	^ self char8Type const arraySlice
]

{ #category : #initialization }
TMbndCoreCompilationTarget >> standardConcreteTypeForSymbolInScope: aScope [
	aScope isCompilationEvaluationScope ifTrue: [ ^ self compilerObjectType ].
	self managedObjectModel symbolClass ifNotNil: [ ^ self managedObjectModel symbolClass ].
	self error: 'Unsupported symbols at this context.'
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sysmelAtExitFunction [
	^ sysmelAtExitFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> sysmelAtExitFunction: aFunction [
	sysmelAtExitFunction := aFunction
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
	^ tupleTypes getOrCreateInstanceWithArguments: { elements asArray }
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> type: baseType withDecorations: decorations [
	decorations ifEmpty: [ ^ baseType ].
	^ decoratedTypes getOrCreateInstanceWithArguments: { baseType . decorations }
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> typeInformationClass [
	^ typeInformationClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> typeInformationClass: aClass [
	^ typeInformationClass := aClass
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> variantUnexpectedComponentRaiseFunction [
	^ variantUnexpectedComponentRaiseFunction
]

{ #category : #accessing }
TMbndCoreCompilationTarget >> variantUnexpectedComponentRaiseFunction: aFunction [
	variantUnexpectedComponentRaiseFunction := aFunction
]

{ #category : #'derived types' }
TMbndCoreCompilationTarget >> variantUnionTypeWithComponents: components [
	| setElements nonDuplicated |
	setElements := Set new.
	nonDuplicated := OrderedCollection new.
	components do: [ :each |
		(setElements includes: each) ifFalse: [
			setElements add: each.
			nonDuplicated add: each
		]
	].

	^ variantUnions getOrCreateInstanceWithArguments: {nonDuplicated asArray}.
]
