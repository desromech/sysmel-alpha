Class {
	#name : #MbndAbstractConcreteCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'instance creation' }
MbndAbstractConcreteCompilationTarget class >> for: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget
]

{ #category : #'derived types' }
MbndAbstractConcreteCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
]

{ #category : #'as yet unclassified' }
MbndAbstractConcreteCompilationTarget >> initializeDerivedTypeCaches [
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

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerSize [
	self subclassResponsibility
]
