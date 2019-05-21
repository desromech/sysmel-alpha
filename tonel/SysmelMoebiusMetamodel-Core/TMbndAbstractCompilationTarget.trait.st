Trait {
	#name : #TMbndAbstractCompilationTarget,
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'as yet unclassified' }
TMbndAbstractCompilationTarget >> arrayOf: elementType elements: elementCount [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> astNodeType [
	^ self getBasicTypeNamed: MbndASTNodeType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> booleanType [
	^ self getBasicTypeNamed: #BooleanBit
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

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float16Type [
	^ self getBasicTypeNamed: #Float16
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float32Type [
	^ self getBasicTypeNamed: #Float32
]

{ #category : #accessing }
TMbndAbstractCompilationTarget >> float64Alignment [
	^ self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> float64Type [
	^ self getBasicTypeNamed: #Float64
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

{ #category : #accessing }
TMbndAbstractCompilationTarget >> getBasicTypeNamed: typeName [
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
TMbndAbstractCompilationTarget >> isWin32 [
	^ false
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
TMbndAbstractCompilationTarget >> literalFloatType [
	^ self getBasicTypeNamed: #_LiteralFloat
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> literalIntegerType [
	^ self getBasicTypeNamed: #_LiteralInteger
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

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> metaBuilderInstanceType [
	^ self getBasicTypeNamed: MbndMetaBuilderInstanceType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> namespaceType [
	^ self getBasicTypeNamed: MbndNamespaceType typeName
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> opaqueType [
	^ self getBasicTypeNamed: MbndOpaqueType typeName
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> pointerFor: addressSpace to: baseType [
	self explicitRequirement
]

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> pointerTo: baseType [
	^ self pointerFor: MbndPointerLikeType genericAddressSpace to: baseType
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
TMbndAbstractCompilationTarget >> type: baseType withDecorations: decorations [
	self explicitRequirement
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

{ #category : #'derived types' }
TMbndAbstractCompilationTarget >> variantUnionTypeWithComponents: components [
	self explicitRequirement
]

{ #category : #'convenience type accessors' }
TMbndAbstractCompilationTarget >> voidType [
	^ self getBasicTypeNamed: MbndVoidType typeName
]
