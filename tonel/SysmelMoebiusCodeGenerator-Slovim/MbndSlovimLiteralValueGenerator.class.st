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

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue [
	^ literalValue
]

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue: anObject [
	literalValue := anObject
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> translateLiteralValue: theLiteralValueToTranslate ofType: literalType [
	literalValue := theLiteralValueToTranslate.
	^ literalType accept: self
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitAggregateType: type [
	| slots convertedSlots slvmType hasBiggerArrayAtTheEnd |
	slots := literalValue slots.
	convertedSlots := type slotLayout slots collectWithIndex: [ :slot :index |
		codeModuleGenerator translateLiteralValue: (slots at: index) ofType: slot type
	].

	slvmType := codeModuleGenerator translateType: type.
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
			[slotType elements > expectedType elements]]]]) ifTrue: [
				hasBiggerArrayAtTheEnd := true
			] ifFalse: [
				self error: 'Invalid aggregate literal value with mismatching slot types.'
			]
		].
	].

	hasBiggerArrayAtTheEnd ifTrue: [
		slvmType := SLVMStructureType name: nil types: (convertedSlots collect: #type) kind: slvmType kind names: slvmType names.
	].

	^ SLVMConstant structure: slvmType slots: convertedSlots
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
		codeModuleGenerator translateLiteralValue: slot ofType: elementType
	].

	^ SLVMConstant array: slvmArrayType slots: convertedSlots
	
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitClassType: type [
	^ self visitAggregateType: type
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitDecoratedType: decoratedType [
	^ decoratedType baseType accept: self

]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitLiteralValueType: type [
	^ literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPointerType: pointerType [
	| baseType undecoratedBaseType |
	(literalValue isNil or: [ literalValue isInteger ]) ifTrue: [
		^ SLVMConstant type: (self translateType: pointerType) value: literalValue
	].

	baseType := pointerType baseType.
	undecoratedBaseType := pointerType baseType withoutDecorations.
	literalValue isString ifTrue: [
		(baseType isConstantType and:
		[ undecoratedBaseType isPrimitiveIntegerType]) ifTrue: [ 
			undecoratedBaseType instanceSize = 1 ifTrue: [ 
				^ SLVMConstant pointerToConstant: (SLVMConstant cstring: literalValue)
					pointerType: (self translateType: pointerType)
			]
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
MbndSlovimLiteralValueGenerator >> visitPrimitiveFloatType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveIntegerType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitReferenceType: referenceType [
	^ SLVMConstant pointerToConstant: (referenceType baseType accept: self) pointerType: (self translateType: referenceType)
]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitStructureType: type [
	^ self visitAggregateType: type
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitUndefinedType: undefinedType [
	^ SLVMConstant type: (self translateType: undefinedType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitVoidType: voidType [
	^ nil
]
