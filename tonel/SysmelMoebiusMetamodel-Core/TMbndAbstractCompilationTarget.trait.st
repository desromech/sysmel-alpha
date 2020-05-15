Trait {
	#name : #TMbndAbstractCompilationTarget,
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> areSymbolsEqualsToString [
	"This is the default Pharo behavior"
	^ true
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> arrayOf: elementType elements: elementCount [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> arraySliceOf: elementType [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> astNodeType [
	^ self getBasicTypeNamed: MbndASTNodeType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> basicType [
	^ self getBasicTypeNamed: MbndBasicType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> behaviorType [
	^ self getBasicTypeNamed: MbndBehaviorType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> blockClosureTypeWithSignature: functionType [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> booleanType [
	^ self getBasicTypeNamed: #Boolean8
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> char16Type [
	^ self getBasicTypeNamed: #Char16
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> char32Type [
	^ self getBasicTypeNamed: #Char32
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> char8Type [
	^ self getBasicTypeNamed: #Char8
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> compilerObjectType [
	^ self getBasicTypeNamed: MbndCompilerObjectType typeName
]

{ #category : #coercing }
TMbndAbstractCompilationTarget >> computeArithmeticCoercionTypeFor: leftType with: rightType [
	self subclassResponsibility
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> cstringLiteralType [
	^ self uint8Type const pointer
]

{ #category : #'calling conventions' }
TMbndAbstractCompilationTarget >> defaultCallingConvention [
	^ #cdecl
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> dynamicObjectType [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> extensionForModuleOutputMode: outputMode [
	outputMode = #llvm_assembly ifTrue: [ ^ '.ll' ].
	outputMode = #assembly ifTrue: [ ^ '.s' ].
	outputMode = #executable ifTrue: [
		self isWin32 ifTrue: [ ^ '.exe' ].
		^ ''
	].
	outputMode = #shared ifTrue: [ 
		self isWin32 ifTrue: [ ^ '.dll' ].
		self isOSX ifTrue: [ ^ '.dylib' ].
		^ '.so'
	].
	outputMode = #object ifTrue: [ 
		self isWin32 ifTrue: [ ^ '.obj' ].
		^ '.o'
	].

	self error: 'Unsupported output mode.'
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float16Type [
	^ self getBasicTypeNamed: #Float16
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32Type [
	^ self getBasicTypeNamed: #Float32
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x2Type [
	^ self getBasicTypeNamed: #Float32x2
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x2x2Type [
	^ self getBasicTypeNamed: #Float32x2x2
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x3Type [
	^ self getBasicTypeNamed: #Float32x3
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x3x3Type [
	^ self getBasicTypeNamed: #Float32x3x3
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x4Type [
	^ self getBasicTypeNamed: #Float32x4
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32x4x4Type [
	^ self getBasicTypeNamed: #Float32x4x4
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> float64Alignment [
	^ self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float64Type [
	^ self getBasicTypeNamed: #Float64
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float64x2Type [
	^ self getBasicTypeNamed: #Float64x2
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float64x3Type [
	^ self getBasicTypeNamed: #Float64x3
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float64x4Type [
	^ self getBasicTypeNamed: #Float64x4
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> functionGroupType [
	^ self getBasicTypeNamed: MbndFunctionGroupType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> functionTemplateType [
	^ self getBasicTypeNamed: MbndFunctionTemplateType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType [
	^ self functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: self defaultCallingConvention
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention [
	^ self functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: false
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: callingConvention cvariadic: cvariadic [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> functionTypeWithArguments: argumentTypes returnType: returnType cvariadic: cvariadic [
	^ self functionTypeWithArguments: argumentTypes returnType: returnType callingConvention: self defaultCallingConvention cvariadic: cvariadic
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> gcBlockClosureType [
	^ self getBasicTypeNamed: #_GCBlockClosureType
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> getBasicTypeNamed: typeName [
	self explicitRequirement
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuDepthTexture2DArrayType [
	^ self getBasicTypeNamed: #GPUDepthTexture2DArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuDepthTexture2DType [
	^ self getBasicTypeNamed: #GPUDepthTexture2D
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuDepthTextureCubeArrayType [
	^ self getBasicTypeNamed: #GPUDepthTextureCubeArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuDepthTextureCubeType [
	^ self getBasicTypeNamed: #GPUDepthTextureCube
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuSamplerType [
	^ self getBasicTypeNamed: #GPUSampler
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture1DArrayType [
	^ self getBasicTypeNamed: #GPUTexture1DArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture1DType [
	^ self getBasicTypeNamed: #GPUTexture1D
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture2DArrayType [
	^ self getBasicTypeNamed: #GPUTexture2DArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture2DType [
	^ self getBasicTypeNamed: #GPUTexture2D
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture3DArrayType [
	^ self getBasicTypeNamed: #GPUTexture3DArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTexture3DType [
	^ self getBasicTypeNamed: #GPUTexture3D
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTextureCubeArrayType [
	^ self getBasicTypeNamed: #GPUTextureCubeArray
]

{ #category : #'gpu convenience type accessors' }
TMbndAbstractCompilationTarget >> gpuTextureCubeType [
	^ self getBasicTypeNamed: #GPUTextureCube
]

{ #category : #initialization }
TMbndAbstractCompilationTarget >> hasBoundsChecks [
	^ self isGPU not
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> hasNoOperatingSystem [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> hasOperatingSystem [
	^ self hasNoOperatingSystem not and: [ self isGPU not ]
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> inputChannelFor: messageType specialSemantics: specialSemantics [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int16Type [
	^ self getBasicTypeNamed: #Int16
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int32Type [
	^ self getBasicTypeNamed: #Int32
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int32x2Type [
	^ self getBasicTypeNamed: #Int32x2
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int32x3Type [
	^ self getBasicTypeNamed: #Int32x3
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int32x4Type [
	^ self getBasicTypeNamed: #Int32x4
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> int64Alignment [
	^ self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int64Type [
	^ self getBasicTypeNamed: #Int64
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> int8Type [
	^ self getBasicTypeNamed: #Int8
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> intPointerType [
	^ self getBasicTypeNamed: #IntPointer
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isFreeBSD [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isGPU [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isLinux [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isOSX [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isUnix [
	^ self isLinux or: [ self isOSX or: [ self isFreeBSD ] ]
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isWebAssembly [
	^ false
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> isWin32 [
	^ false
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalArrayType [
	^ self getBasicTypeNamed: #_LiteralArray
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalAssociationType [
	^ self getBasicTypeNamed: #_LiteralAssociation
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalBooleanFalseType [
	^ self getBasicTypeNamed: #_LiteralBooleanFalse
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalBooleanTrueType [
	^ self getBasicTypeNamed: #_LiteralBooleanTrue
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalBooleanType [
	^ self getBasicTypeNamed: #_LiteralBoolean
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalByteArrayType [
	^ self getBasicTypeNamed: #_LiteralByteArray
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalCharacterType [
	^ self getBasicTypeNamed: #_LiteralCharacter
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalDictionaryType [
	^ self getBasicTypeNamed: #_LiteralDictionary
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalFloatType [
	^ self getBasicTypeNamed: #_LiteralFloat
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalIntegerType [
	^ self getBasicTypeNamed: #_LiteralInteger
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalIntervalType [
	^ self getBasicTypeNamed: #_LiteralInterval
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalStringType [
	^ self getBasicTypeNamed: #_LiteralString
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalSymbolType [
	^ self getBasicTypeNamed: #_LiteralSymbol
]

{ #category : #'builder methods' }
TMbndAbstractCompilationTarget >> lookupTypeWithName: typeName [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> managedObjectModel [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> messageTemplateType [
	^ self getBasicTypeNamed: MbndMessageTemplateType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> metaBuilderInstanceType [
	^ self getBasicTypeNamed: MbndMetaBuilderInstanceType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> methodTemplateType [
	^ self getBasicTypeNamed: MbndMethodTemplateType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> namespaceType [
	^ self getBasicTypeNamed: MbndNamespaceType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> nativeBlockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asNativeBlockClosureType
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> nativeBlockClosureTypeWithSignature: functionType [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> opaqueType [
	^ self getBasicTypeNamed: MbndOpaqueType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> outputChannelFor: messageType specialSemantics: specialSemantics [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> patternMatchingPatternType [
	^ self getBasicTypeNamed: MbndPatternMatchingPatternType typeName
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> pointerAlignment [
	^ self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> pointerFor: addressSpace to: baseType [
	self explicitRequirement
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> pointerSize [
	^ self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> pointerTo: baseType [
	^ self pointerFor: MbndPointerLikeType genericAddressSpace to: baseType
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> primitiveCharacterCodeType [
	^ self getBasicTypeNamed: #_PrimitiveCharacterCodeType
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> primitiveFloatType [
	^ self getBasicTypeNamed: #_PrimitiveFloatType
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> primitiveIntegerType [
	^ self getBasicTypeNamed: #_PrimitiveIntegerType
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> primitiveMatrixTypeFor: elementType rows: rowCount columns: columnCount [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> primitiveVectorTypeFor: elementType elements: vectorSize [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> referenceFor: addressSpace to: baseType [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> referenceTo: baseType [
	^ self referenceFor: MbndPointerLikeType genericAddressSpace to: baseType
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> returnType [
	^ self getBasicTypeNamed: #_ReturnType
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> simpleMetaType [
	^ self getBasicTypeNamed: MbndSimpleMetaType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> specificCompilerObjectTypeFor: aBehavior [
	self explicitRequirement
]

{ #category : #'platform testing' }
TMbndAbstractCompilationTarget >> standardMathLibraryLinkerArguments [
	self isUnix ifTrue: [ ^ #('-lm') ].
	^ #()
]

{ #category : #testing }
TMbndAbstractCompilationTarget >> supportsLocalAddressForThisContext [
	<compileTime>
	^ false
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> templateType [
	^ self getBasicTypeNamed: MbndTemplateType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> temporaryReferenceFor: addressSpace to: baseType [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> temporaryReferenceTo: baseType [
	^ self temporaryReferenceFor: MbndPointerLikeType genericAddressSpace to: baseType
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> type: baseType withDecorations: decorations [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> typeTemplateType [
	^ self getBasicTypeNamed: MbndTypeTemplateType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> typeTypeConcept [
	^ self getBasicTypeNamed: MbndTypeTypeConcept typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint16Type [
	^ self getBasicTypeNamed: #UInt16
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint32Type [
	^ self getBasicTypeNamed: #UInt32
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint32x2Type [
	^ self getBasicTypeNamed: #UInt32x2
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint32x3Type [
	^ self getBasicTypeNamed: #UInt32x3
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint32x4Type [
	^ self getBasicTypeNamed: #UInt32x4
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint64Type [
	^ self getBasicTypeNamed: #UInt64
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uint8Type [
	^ self getBasicTypeNamed: #UInt8
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> uintPointerType [
	^ self getBasicTypeNamed: #UIntPointer
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> undefinedType [
	^ self getBasicTypeNamed: MbndUndefinedType typeName
]

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> usesExceptionsForNonLocalReturns [
	^ self isGPU not
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> variantUnionTypeWithComponents: components [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> voidType [
	^ self getBasicTypeNamed: MbndVoidType typeName
]
