Class {
	#name : #MbndSlovimTypeTranslator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'translatedTypes'
	],
	#classVars : [
		'ShaderAdressSpaceMap',
		'ShaderOpaqueAddressSpaces'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTypeTranslator class >> initialize [
	ShaderOpaqueAddressSpaces := Set newFrom: #(
		bindingSet
		uniformBuffer
		storageBuffer
	).
	
	ShaderAdressSpaceMap := Dictionary newFromPairs: #(
		uniformBuffer uniform
		storageBuffer uniform
		generic function
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTypeTranslator >> importTranslatedType: aType fromModule: typeDefinitionModule [
	| importedSSAModule importedType |
	self assert: aType isAggregateType.
	importedSSAModule := typeDefinitionModule namedTargetCodeModules at: codeModuleGenerator targetCodeModuleName ifAbsent: [
		self error: 'Required translated type {1} imported from module [3]{2} target is not found.' format: { aType asString . typeDefinitionModule name . codeModuleGenerator targetCodeModuleName asString }
	].
	importedType := importedSSAModule highLevelMapToStructureType at: aType.
	codeModuleGenerator ssaModule
		importType: importedType fromModule: importedSSAModule;
		addHighLevelEntity: aType mapToStructureType: importedType.
	aType isGCClassType ifTrue: [
		^ SLVMPointerType size: self slvmCompilationTarget pointerSize baseType: importedType storage: SLVMType gcStorage
	].

	^ importedType
]

{ #category : #initialization }
MbndSlovimTypeTranslator >> initialize [
	super initialize.
	translatedTypes := Dictionary new.
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> setType: type ssaType: ssaType [
	translatedTypes at: type put: ssaType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateAggregateType: aggregateType [
	^ self translateAggregateType: aggregateType withKind: SLVMStructureType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateAggregateType: aggregateType withKind: typeKindClass [
	| structureName ssaStructureType ssaValueType |
	
	aggregateType isSpecialStructureType ifTrue: [ 
		structureName := aggregateType unmangledSpecialStructureName
	].
	
	structureName ifNil: [ 
		structureName := (aggregateType name isNotNil or: [aggregateType parent isNotNil and: [aggregateType parent isTemplateInstance]]) ifTrue: [
			(aggregateType unmangledStructureTypePrefix , (codeModuleGenerator unmangledNameForProgramEntity: aggregateType)) asSymbol
		].
		(aggregateType isGCClassType and: [ aggregateType isMetaType ]) ifTrue: [ 
			structureName := (aggregateType unmangledStructureTypePrefix ,  (codeModuleGenerator unmangledNameForProgramEntity: aggregateType instanceType) , '::__Meta__') asSymbol
		].
	].

	ssaStructureType := typeKindClass name: structureName
		types: #() kind: typeKindClass genericKind names: #().

	ssaValueType := ssaStructureType.
	aggregateType isGCClassType ifTrue: [ 
		ssaValueType := SLVMPointerType
			size: self slvmCompilationTarget pointerSize
			baseType: ssaStructureType
			storage: #gc.
	].

	translatedTypes at: aggregateType put: ssaValueType.

	aggregateType isDefined ifTrue: [
		ssaStructureType
			names: (aggregateType slotLayout slots collect: [:each | each name]);
			types: (aggregateType slotLayout slots collect: [:slot | self sanitizeStructureFieldType: (self translateType: slot type)]);
			minimalAlignment: aggregateType slotLayout instanceAlignment.
	].
		
	^ ssaValueType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateType: aType [
	^ translatedTypes at: aType ifAbsentPut: [
		(aType isModuleSpecificType and: [aType module ~~ codeModuleGenerator sourceModule]) ifTrue: [
			self importTranslatedType: aType fromModule: aType module
		] ifFalse: [ 
			aType isTrait ifFalse: [
				aType accept: self
			] ifTrue: [
				self halt
			].
		]
	]

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateTypes: aCollectionOfTypes [
	^ aCollectionOfTypes collect: [ :type | self translateType: type ]
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitArraySliceType: type [
	^ self visitSpecialStructureType: type
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitArrayType: arrayType [
	| elementType |
	elementType := self translateType: arrayType elementType.
	^ SLVMArrayType baseType: elementType elements: (arrayType elements > 0 ifTrue: [arrayType elements] ifFalse: [nil])
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitAssociationType: type [
	^ self visitSpecialStructureType: type
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitBlockClosureType: type kind: closureKind addressSpace: addressSpace [
	| headerType functionPointerType |
	headerType := self slvmCompilationTarget objectModel closureHeaderTypeForKind: closureKind.
	self assert: headerType isNotNil.
	functionPointerType := self translateType: type functionTypeWithGenericClosurePointer pointer.
	
	^ self slvmCompilationTarget
		pointerTo: (SLVMStructureType name: nil types: { headerType . functionPointerType } kind: SLVMStructureType genericKind names: #(vtable functionPointer))
		storage: addressSpace 
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitClassType: structureType [
	^ self translateAggregateType: structureType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitCompilerObjectType: type [
	^ self translateType: type underlyingObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitDecoratedType: type [
	^ self translateType: type baseType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitEnumType: enumType [
	^ self translateType: enumType baseType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitFunctionType: functionType [
	| argumentSSATypes returnSSAType concreteArgumentTypes concreteReturnType |
	concreteArgumentTypes := functionType argumentTypes collect: [:type | type asConcreteTypeForAnalysisOfFunctionType: functionType].
	concreteReturnType := functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType.
	
	argumentSSATypes := Array streamContents: [:out |
		concreteArgumentTypes do: [ :argumentType |
			argumentType isTypePassedByReference ifTrue: [
				out nextPut: (self slvmCompilationTarget pointerTo: (self translateType: argumentType))
			] ifFalse: [ 
				out nextPut: (self translateType: argumentType)
			].
		].
	].

	concreteReturnType isMemoryReturnedType ifTrue: [
		argumentSSATypes := {self slvmCompilationTarget pointerTo: (self translateType: concreteReturnType)} , argumentSSATypes.
		returnSSAType := SLVMType voidType.
	] ifFalse: [
		returnSSAType := self translateType: concreteReturnType
	].
	
	^ (SLVMFunctionType callingConvention: functionType callingConvention arguments: argumentSSATypes returnType: returnSSAType)
		variadic: functionType cvariadic;
		yourself
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitGCBlockClosureType: type [
	^ self visitBlockClosureType: type kind: #gc addressSpace: #gc
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitGCClassType: structureType [
	^ self translateAggregateType: structureType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitGCClassVariableDataArrayType: variableDataArrayType [
	| elementType |
	elementType := self translateType: variableDataArrayType elementType.
	^ SLVMArrayType baseType: elementType elements: 0
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitInputChannelType: type [
	| messageType |
	type specialSemantics ifNotNil: [
		messageType := self translateType: type messageType.
		^ self slvmCompilationTarget pointerTo: messageType storage: SLVMType functionStorage
	].

	codeModuleGenerator compilationTarget inputChannelImplementationType ifNotNil: [ :targetType | ^ self translateType: targetType ].
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: targetType ].
	^ self slvmCompilationTarget dynamicObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitNamespaceType: namespaceType [
	^ self compilationTarget moduleNamespaceInformationClass ifNotNil: [ :cls |
		cls isGarbageCollectedType ifTrue: [
			self translateType: cls
		] ifFalse: [
			self translateType: cls pointer
		]
	] ifNil: [
		self slvmCompilationTarget voidPointerType
	]
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitNativeBlockClosureType: type [
	^ self visitBlockClosureType: type kind: #nativeStack addressSpace: #generic
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitOutputChannelType: type [
	| messageType |
	type specialSemantics ifNotNil: [
		messageType := self translateType: type messageType.
		^ self slvmCompilationTarget pointerTo: messageType storage: SLVMType functionStorage
	].

	codeModuleGenerator compilationTarget outputChannelImplementationType ifNotNil: [ :targetType | ^ self translateType: targetType ].
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: targetType ].
	^ self slvmCompilationTarget dynamicObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPointerType: pointerType [
	"This could be a recursive type."
	| ssaPointerType actualAddressSpace |
	actualAddressSpace := pointerType addressSpace.
	self slvmCompilationTarget isGPU ifTrue: [ 
		actualAddressSpace := ShaderAdressSpaceMap at: actualAddressSpace ifAbsent: [ actualAddressSpace ].
	].

	ssaPointerType := SLVMPointerType new
		size: self slvmCompilationTarget pointerSize;
		storage: actualAddressSpace;
		yourself.
	translatedTypes at: pointerType put: ssaPointerType.
	
	ssaPointerType baseType: (self translateType: pointerType baseType).
	self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
		ssaPointerType baseType isBooleanType ifTrue: [ 
			ssaPointerType baseType: self slvmCompilationTarget uchar
		]
	].
	^ ssaPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveBooleanType: integerType [
	self error: 'Unsupported primitive type.'
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveCharacterCodeType: integerType [
	self halt
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveIntegerType: integerType [
	self halt
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveMatrixType: matrixType [
	^ SLVMMatrixType baseType: (self translateType: matrixType elementType) rows: matrixType rows columns: matrixType columns alignment: matrixType instanceAlignment

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveVectorType: vectorType [
	^ SLVMVectorType baseType: (self translateType: vectorType elementType) elements: vectorType elements alignment: vectorType instanceAlignment

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitReferenceType: referenceType [
	^ self translateType: referenceType asPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitSamplerType: type [
	^ self slvmCompilationTarget voidPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitSimpleMetaType: metaType [
	metaType instanceType ifNotNil: [ :it |
		it programEntityInformationDataClass ifNotNil: [ :typeInfoClass |
			^ self translateType: (typeInfoClass isGarbageCollectedType
				ifTrue: [ typeInfoClass ]
				ifFalse: [typeInfoClass pointer])
		].
	].

	metaType programEntityInformationDataClass ifNotNil: [ :typeInfoClass |
		^ self translateType: (typeInfoClass isGarbageCollectedType
			ifTrue: [ typeInfoClass ]
			ifFalse: [typeInfoClass pointer])
	].

	^ self slvmCompilationTarget voidPointerPointerType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitSpecialStructureType: specialStructureType [
	| result |
	result := self visitStructureType: specialStructureType.
	result name ifNotNil: [
		codeModuleGenerator ssaModule addStructure: result
	].

	^ result
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitStructureType: structureType [
	^ self translateAggregateType: structureType withKind: (structureType
		isPacked
			ifTrue: [SLVMPackedStructureType]
			ifFalse: [SLVMStructureType])

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitTemporaryReferenceType: referenceType [
	^ self translateType: referenceType asPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitTextureType: type [
	^ self slvmCompilationTarget voidPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitTupleType: tupleType [
	| ssaValueType |
	ssaValueType := SLVMStructureType name: nil
		types: (tupleType elements collect: [:each | self translateType: each])
		kind: SLVMStructureType genericKind
		names: ((0 to: tupleType elements size - 1) collect: [:each | ('element', each asString) asSymbol]).
	translatedTypes at: tupleType put: ssaValueType.
	
	^ ssaValueType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitUnionType: structureType [
	^ self translateAggregateType: structureType withKind: SLVMUnionType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitVariantUnionType: variantType [
	| ssaUnionType ssaValueType |
	ssaUnionType := SLVMUnionType name: nil
		types: (variantType components collect: [:each | self translateType: each])
		kind: SLVMStructureType genericKind
		names: ((0 to: variantType components size - 1) collect: [:each | ('component', each asString) asSymbol]).
	ssaValueType := SLVMStructureType name: nil
		types: { SLVMType ucharType . ssaUnionType }
		kind: SLVMStructureType genericKind
		names: #(typeSelector union).
	translatedTypes at: variantType put: ssaValueType.
	
	^ ssaValueType
]
