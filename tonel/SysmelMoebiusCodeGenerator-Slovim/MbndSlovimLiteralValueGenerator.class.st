Class {
	#name : #MbndSlovimLiteralValueGenerator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'literalValue'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> ensureValidSSALiteralValue: convertedLiteralValue ofType: literalType [
	| expectedTargetType |
	(convertedLiteralValue isSLVMObject and: [ convertedLiteralValue isSSAValue ]) ifTrue: [
		literalType isGarbageCollectedType ifTrue: [ 
			expectedTargetType := self translateType: literalType.
			convertedLiteralValue type ~~ literalType type ifTrue: [ 
				convertedLiteralValue isFunction ifTrue: [ 
					^ SLVMConstant value: convertedLiteralValue compiledMethodMetaDataValue bitcast: expectedTargetType
				].
				^ SLVMConstant value: convertedLiteralValue bitcast: expectedTargetType
			]
		].
		^ convertedLiteralValue
	].
	convertedLiteralValue isMbndProgramEntity ifTrue: [
		^ self ensureValidSSALiteralValue: (self translateProgramEntity: convertedLiteralValue) ssaValue ofType: literalType
	].

	self assert: literalType isGarbageCollectedType.
	^ self ensureValidSSALiteralValue: (self slvmCompilationTarget objectModel convertDynamicLiteralToConstant: convertedLiteralValue) ofType: literalType
]

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue [
	^ literalValue
]

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue: anObject [
	literalValue := anObject
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> sanitizeAggregateConstantMember: constantMember [
	constantMember type isBooleanType ifTrue: [
		self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
			constantMember isConstantValue ifTrue: [ 
				^ SLVMConstant uchar: constantMember value asBit
			]
		].
	].

	(constantMember type isVectorType and: [ constantMember type baseType isBooleanType ]) ifTrue: [
		self slvmCompilationTarget isLLVMCompilationTarget ifTrue: [ 
			| expectedValueType |
			expectedValueType := self sanitizeValueTypeForMemory: constantMember type.
			constantMember isConstantVectorValue ifTrue: [ 
				^ SLVMConstant vector: expectedValueType elements: (constantMember slots collect: [:each | self sanitizeAggregateConstantMember: each])
			]
		].
	].

	^ constantMember
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> translateDynamicObjectInstanceContent: dynamicObject [
	literalValue := dynamicObject.
	^ self visitAggregateType: dynamicObject type
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> translateLiteralValue: theLiteralValueToTranslate ofType: literalType [
	literalValue := theLiteralValueToTranslate.
	^ literalType accept: self
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> translateObject: targetType content: content [
	literalValue := content.
	targetType isGarbageCollectedType ifTrue: [ 
		^ self visitAggregateType: targetType
	].

	literalValue ifNil: [ ^ (self translateType: targetType) baseType defaultConstant ].
	^ self visitAggregateType: literalValue type
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitAggregateType: type [
	| slots convertedSlots slvmType hasBiggerArrayAtTheEnd |
	literalValue isString ifTrue: [ 
		self assert: type isArraySliceType.
		literalValue := MbndAggregateTypeInstanceValue new
			type: type;
			slots: {literalValue . literalValue size};
			yourself.
	].
	slots := literalValue slots.

	convertedSlots := type slotLayout slots collectWithIndex: [ :slot :index |
		self sanitizeAggregateConstantMember:
		(self ensureValidSSALiteralValue: (codeModuleGenerator translateLiteralValue: (slots at: index) ofType: slot type)
			ofType: slot type)
	].

	slvmType := codeModuleGenerator translateType: type.
	type isGarbageCollectedType ifTrue: [ slvmType := slvmType baseType ].
	
	hasBiggerArrayAtTheEnd := false.
	convertedSlots doWithIndex: [ :convertedSlot :index |
		|slotType expectedType|
		slotType := convertedSlot type.
		expectedType := slvmType types at: index.
		slotType ~= expectedType ifTrue: [
			(index = convertedSlots size and:
			[slotType isArrayType and:
			[expectedType isArrayType and:
			[slotType baseType = expectedType baseType and:
			[slotType elements >= expectedType validElements ]]]]) ifTrue: [
				hasBiggerArrayAtTheEnd := true
			] ifFalse: [
				self error: 'Invalid aggregate literal value with mismatching slot types.'
			]
		].
	].

	hasBiggerArrayAtTheEnd ifTrue: [
		slvmType := SLVMStructureType name: nil types: (convertedSlots collect: [:each | each type]) kind: slvmType kind names: slvmType names.
	].

	^ SLVMConstant structure: slvmType slots: convertedSlots
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitArraySliceType: specialStructure [
	^ self visitSpecialStructureType: specialStructure
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitArrayType: arrayType [
	| elementType slvmElementType slvmArrayType convertedSlots |
	elementType := arrayType elementType.
	slvmElementType := self translateType: arrayType elementType.
	slvmArrayType := SLVMArrayType baseType: slvmElementType elements: literalValue slots size.
	literalValue slots class == ByteArray ifTrue: [
		^ SLVMConstant array: slvmArrayType blob: literalValue slots
	].
	literalValue slots class == ByteString ifTrue: [
		^ SLVMConstant array: slvmArrayType blob: literalValue slots asByteArray
	].
	
	convertedSlots := literalValue slots collect: [ :slot |
		self ensureValidSSALiteralValue: (codeModuleGenerator translateLiteralValue: slot ofType: elementType) ofType: elementType
	].

	^ SLVMConstant array: slvmArrayType slots: convertedSlots
	
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitAssociationType: specialStructure [
	^ self visitSpecialStructureType: specialStructure
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitClassType: type [
	^ self visitAggregateType: type
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitDecoratedType: decoratedType [
	^ decoratedType baseType accept: self

]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitEnumType: enumType [
	^ enumType baseType accept: self
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitFunctionType: type [
	self halt.
	literalValue isMbndProgramEntity ifTrue: [ ^ (self translateProgramEntity: literalValue) ssaValue ].
	self halt
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitGCBlockClosureType: closureType [
	literalValue ifNil: [ ^ self visitPointerType: closureType ].
	self halt
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitGCClassType: type [
	| objectModel targetType |
	targetType := self translateType: type.
	objectModel := self slvmCompilationTarget objectModel.
	^ (objectModel isInlineLiteral: literalValue) ifTrue: [
		objectModel convertInlineLiteral: literalValue withType: targetType.
	] ifFalse: [ 
		objectModel convertNonInlineLiteral: literalValue.
	].
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitGCClassVariableDataArrayType: type [
	^ self visitArrayType: type
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitLiteralValueType: type [
	^ literalValue
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitNamespaceType: type [
	^ (codeModuleGenerator translateProgramEntity: literalValue) ssaValue
]

{ #category : #'as yet unclassified' }
MbndSlovimLiteralValueGenerator >> visitNativeBlockClosureType: type [
	literalValue ifNil: [ ^ self visitPointerType: type ].
	self halt
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPointerType: pointerType [
	| baseType undecoratedBaseType |
	(literalValue isNil or: [ literalValue isInteger ]) ifTrue: [
		^ SLVMConstant type: (self translateType: pointerType) value: literalValue
	].

	(literalValue isSLVMObject and: [ literalValue isConstant ]) ifTrue: [ 
		^ SLVMConstant value: literalValue bitcast: (self translateType: pointerType)
	].

	baseType := pointerType baseType.
	undecoratedBaseType := pointerType baseType withoutDecorations.
	literalValue isString ifTrue: [
		(baseType isConstantType and:
		[ undecoratedBaseType isPrimitiveIntegerType]) ifTrue: [ 
			undecoratedBaseType instanceSize = 1 ifTrue: [ 
				^ SLVMConstant pointerToConstant: (SLVMConstant cstring: literalValue slvmUTF8Encoded)
					pointerType: (self translateType: pointerType)
			].
			undecoratedBaseType instanceSize = 2 ifTrue: [ 
				^ SLVMConstant pointerToConstant: (SLVMConstant cwstring: literalValue slvmUTF16Encoded)
					pointerType: (self translateType: pointerType)
			].
			undecoratedBaseType instanceSize = 4 ifTrue: [ 
				^ SLVMConstant pointerToConstant: (SLVMConstant clstring: literalValue slvmUTF32Encoded)
					pointerType: (self translateType: pointerType)
			].
		].
	].

	literalValue isMbndVTablePointerValue ifTrue: [
		^ SLVMConstant getReference: (self translateProgramEntity: literalValue vtableFieldDefinition) ssaValue
			element: literalValue vtableFieldDefinition firstMethodSlotIndex
	].

	literalValue isMbndProgramEntity ifTrue: [ 
		^ SLVMConstant pointer: (self translateProgramEntity: literalValue) ssaValue
			castTo: (self translateType: pointerType)
	].

	self error: 'Unsupported generation of literals of type {1}.' format: { pointerType asString }

]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveBooleanType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveCharacterCodeType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue asInteger
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveFloatType: floatType [
	^ SLVMConstant type: (self translateType: floatType) value: (floatType legalizeLiteralValue: literalValue)
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveIntegerType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitPrimitiveMatrixType: type [
	| slvmType columnType |
	slvmType := self translateType: type.
	columnType := type columnType.
	^ SLVMConstant matrix: slvmType columns: (literalValue slots collect: [:slot |
		self translateLiteralValue: slot ofType: columnType
	])
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitPrimitiveVectorType: type [
	| slvmType elementType |
	slvmType := self translateType: type.
	elementType := type elementType.
	^ SLVMConstant vector: slvmType elements: (literalValue slots collect: [:slot |
		self translateLiteralValue: slot ofType: elementType
	])
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitReferenceType: referenceType [
	referenceType baseType isFunctionType ifTrue: [ 
		literalValue isMbndProgramEntity ifTrue: [ ^ (self translateProgramEntity: literalValue) ssaValue ].
		self halt
	].
	^ SLVMConstant pointerToConstant: (referenceType baseType accept: self) pointerType: (self translateType: referenceType)
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitReturnType: voidType [
	^ nil
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitSimpleMetaType: type [
	^ (self translateProgramEntity: literalValue) ssaValue
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitSpecialStructureType: specialStructure [
	^ self visitStructureType: specialStructure
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitStructureType: type [
	^ self visitAggregateType: type
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitTemporaryReferenceType: referenceType [
	^ self visitReferenceType: referenceType
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitTupleType: type [
	| slots convertedSlots slvmType |
	slots := literalValue slots.
	convertedSlots := type elements collectWithIndex: [ :slotType :index |
		self sanitizeAggregateConstantMember:
		(self ensureValidSSALiteralValue: (codeModuleGenerator translateLiteralValue: (slots at: index) ofType: slotType)
			ofType: slotType)
	].

	slvmType := codeModuleGenerator translateType: type.
	type isGarbageCollectedType ifTrue: [ slvmType := slvmType baseType ].
	
	convertedSlots doWithIndex: [ :convertedSlot :index |
		|slotType expectedType|
		slotType := convertedSlot type.
		expectedType := slvmType types at: index.
		slotType ~= expectedType ifTrue: [
			self error: 'Invalid tuple literal value with mismatching slot types.'
		].
	].

	^ SLVMConstant structure: slvmType slots: convertedSlots
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitUndefinedType: undefinedType [
	^ SLVMConstant type: (self translateType: undefinedType) value: literalValue
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitUnionType: type [
	| slvmType |
	slvmType := self translateType: type.
	literalValue isAllZeros ifTrue: [ ^ slvmType defaultConstant ].
	^ SLVMConstant union: slvmType blob: literalValue data
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitVAListType: type [
	| slvmType |
	slvmType := self translateType: type.
	^ SLVMConstant zeroInitializer: slvmType
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitVariantUnionType: type [
	| slvmType |
	slvmType := self translateType: type.
	literalValue isAllZeros ifTrue: [
		^ slvmType defaultConstant 
	].

	self halt.
	^ SLVMConstant union: slvmType blob: literalValue data

]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitVoidType: voidType [
	^ nil
]
