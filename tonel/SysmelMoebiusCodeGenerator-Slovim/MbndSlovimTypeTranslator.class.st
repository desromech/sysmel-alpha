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

{ #category : #initialization }
MbndSlovimTypeTranslator >> initialize [
	super initialize.
	translatedTypes := Dictionary new.
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> sanitizeStructureFieldType: fieldType [
	self slvmCompilationTarget isGPU ifTrue: [ 
		fieldType isPointerType ifTrue: [
			^ self slvmCompilationTarget pointerSize = 4
				ifTrue: [ self slvmCompilationTarget int32 ]
				ifFalse: [ SLVMVectorType baseType: self slvmCompilationTarget int32 elements: 2 ].
		]
	].

	self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
		fieldType isBooleanType ifTrue: [ ^ self slvmCompilationTarget uint8 ]
	].

	^ fieldType
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
	structureName := (aggregateType name isNotNil or: [aggregateType parent isNotNil and: [aggregateType parent isTemplateInstance]]) ifTrue: [
		(aggregateType unmangledStructureTypePrefix , (codeModuleGenerator unmangledNameForProgramEntity: aggregateType)) asSymbol
	].
	(aggregateType isGCClassType and: [ aggregateType isMetaType ]) ifTrue: [ 
		structureName := (aggregateType unmangledStructureTypePrefix ,  (codeModuleGenerator unmangledNameForProgramEntity: aggregateType instanceType) , '::__Meta__') asSymbol
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
			names: (aggregateType slotLayout slots collect: #name);
			types: (aggregateType slotLayout slots collect: [:slot | self sanitizeStructureFieldType: (self translateType: slot type)]).
	].
		
	^ ssaValueType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateType: aType [
	^ translatedTypes at: aType ifAbsentPut: [
		aType isTrait ifFalse: [
			aType accept: self
		] ifTrue: [
			self halt
		].
	]

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateTypes: aCollectionOfTypes [
	^ aCollectionOfTypes collect: [ :type | self translateType: type ]
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitArrayType: arrayType [
	| elementType |
	elementType := self translateType: arrayType elementType.
	^ SLVMArrayType baseType: elementType elements: (arrayType elements > 0 ifTrue: [arrayType elements] ifFalse: [nil])
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitClassType: structureType [
	^ self translateAggregateType: structureType

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
	| argumentSSATypes returnSSAType |
	argumentSSATypes := self translateTypes: (functionType argumentTypes collect: [:type | type asConcreteTypeForAnalysisOfFunctionType: functionType]).
	returnSSAType := self translateType: (functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType).
	^ (SLVMFunctionType callingConvention: functionType callingConvention arguments: argumentSSATypes returnType: returnSSAType)
		variadic: functionType cvariadic;
		yourself
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
	self slvmCompilationTarget isGPU ifTrue: [
		messageType := self translateType: type messageType.
		^ self slvmCompilationTarget pointerTo: messageType storage: SLVMType functionStorage
	].

	codeModuleGenerator compilationTarget inputChannelImplementationType ifNotNil: [ :targetType | ^ self translateType: type ].
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: type ].
	^ self slvmCompilationTarget dynamicObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitOutputChannelType: type [
	| messageType |
	self slvmCompilationTarget isGPU ifTrue: [
		messageType := self translateType: type messageType.
		^ self slvmCompilationTarget pointerTo: messageType storage: SLVMType functionStorage
	].

	codeModuleGenerator compilationTarget outputChannelImplementationType ifNotNil: [ :targetType | ^ self translateType: type ].
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: type ].
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
	codeModuleGenerator compilationTarget samplerImplementationType ifNotNil: [ :targetType | ^ self translateType: type ].
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: type ].
	^ self slvmCompilationTarget dynamicObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitSimpleMetaType: metaType [
	^ self slvmCompilationTarget voidPointerPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitStructureType: structureType [
	^ self translateAggregateType: structureType withKind: (structureType
		isPacked
			ifTrue: [SLVMPackedStructureType]
			ifFalse: [SLVMStructureType])

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitTextureType: type [
	codeModuleGenerator compilationTarget dynamicObjectType ifNotNil: [ :targetType | ^ self translateType: type ].
	^ self slvmCompilationTarget dynamicObjectType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitUnionType: structureType [
	^ self translateAggregateType: structureType withKind: SLVMUnionType

]
