"
A MbndDummyCompilationTargetTest is a test class for testing the behavior of MbndDummyCompilationTarget
"
Class {
	#name : #MbndCompilationTargetTest,
	#superclass : #TestCase,
	#instVars : [
		'compilationTarget',
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Tests-CompilationTarget'
}

{ #category : #testing }
MbndCompilationTargetTest class >> isAbstract [
	^ self == MbndCompilationTargetTest
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testASTNodeType [
	| type |
	type := compilationTarget astNodeType.
	self assert: type isASTNodeType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testArrayType [
	| elementType type|
	elementType := compilationTarget uint8Type.
	type := elementType array: 7.
	self assert: type isArrayType.
	self assert: type elementType equals: elementType.
	self assert: type elements equals: 7.
	self assert: type instanceSize equals: 7.
	self assert: type instanceAlignment equals: 1.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testAsCVariadicType [
	self assert: compilationTarget literalBooleanType asCVariadicType equals: compilationTarget booleanType.
	self assert: compilationTarget booleanType asCVariadicType equals: compilationTarget booleanType.

	self assert: compilationTarget literalIntegerType asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget int8Type asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget uint8Type asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget int16Type asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget uint16Type asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget int32Type asCVariadicType equals: compilationTarget int32Type.
	self assert: compilationTarget uint32Type asCVariadicType equals: compilationTarget uint32Type.
	self assert: compilationTarget int64Type asCVariadicType equals: compilationTarget int64Type.
	self assert: compilationTarget uint64Type asCVariadicType equals: compilationTarget uint64Type.

	self assert: compilationTarget literalFloatType asCVariadicType equals: compilationTarget float64Type.
	self assert: compilationTarget float32Type asCVariadicType equals: compilationTarget float64Type.
	self assert: compilationTarget float64Type asCVariadicType equals: compilationTarget float64Type.

	self assert: compilationTarget float64Type pointer asCVariadicType equals: compilationTarget float64Type pointer.
	self assert: compilationTarget float64Type const asCVariadicType equals: compilationTarget float64Type.
	self assert: compilationTarget float64Type ref asCVariadicType equals: compilationTarget float64Type.

	self assert: compilationTarget undefinedType asCVariadicType equals: compilationTarget voidType pointer.
	
	self should: [compilationTarget voidType asCVariadicType] raise: Error.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testAsPointerType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType ref.
	self assert: type asPointerType isPointerType.
	self assert: type asPointerType baseType equals: baseType.
	self assert: type asPointerType equals: baseType pointer.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testAsReferenceType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType pointer.
	self assert: type asReferenceType isReferenceType.
	self assert: type asReferenceType baseType equals: baseType.
	self assert: type asReferenceType equals: baseType ref.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testAsTemporaryReferenceType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType pointer.
	self assert: type asTemporaryReferenceType isTemporaryReferenceType.
	self assert: type asTemporaryReferenceType baseType equals: baseType.
	self assert: type asTemporaryReferenceType equals: baseType tempRef.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testAssociationType [
	| type type2 |
	type := compilationTarget associationKey: compilationTarget int32Type value: compilationTarget float32Type.
	type2 := compilationTarget int32Type --> compilationTarget float32Type.
	
	self assert: type isAssociationType.
	self assert: type equals: type2.
	self assert: type instanceSize equals: 8.
	self assert: type instanceAlignment equals: 4.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testBlockClosureType [
	| type argumentTypes returnType |
	argumentTypes := {compilationTarget uint8Type . compilationTarget float32Type}.
	returnType := compilationTarget voidType.
	type := compilationTarget blockClosureTypeWithArguments: argumentTypes returnType: returnType.
	self assert: type isFunctionalType.
	self assert: type isBlockClosureType.
	self assert: type argumentTypes equals: argumentTypes.
	self assert: type returnType equals: returnType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testBooleanType [
	| type |
	type := compilationTarget booleanType.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveBooleanType.
	self assert: type valueSize equals: 1.
	self assert: type defaultValue unwrapMbndValue equals: false.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testCStringLiteralType [
	| type |
	type := compilationTarget cstringLiteralType.
	self assert: type isPointerType.
	self assert: type baseType isConstantType.
	self assert: type baseType baseType isPrimitiveIntegerType.
	self assert: type baseType baseType instanceSize equals: 1.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testChar16Type [
	| type |
	type := compilationTarget char16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 2.
	self assert: type isUnsigned.
	self deny: type isSigned.
	self assert: type defaultValue unwrapMbndValue equals: Character null.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testChar32Type [
	| type |
	type := compilationTarget char32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 4.
	self assert: type isUnsigned.
	self deny: type isSigned.
	self assert: type defaultValue unwrapMbndValue equals: Character null.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testChar8Type [
	| type |
	type := compilationTarget char8Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 1.
	self assert: type isUnsigned.
	self deny: type isSigned.
	self assert: type defaultValue unwrapMbndValue equals: Character null.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testClassType [
	| classType classType2 |
	classType := compilationTarget createNamedType: #Test ofKind: MbndClassType.
	classType2 := compilationTarget createNamedType: #Test ofKind: MbndClassType.
	self assert: classType isAbstractClassType.
	self assert: classType isClassType.
	self assert: classType2 isAbstractClassType.
	self assert: classType2 isClassType.
	self assert: classType ~~ classType2
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testCompilerObjectType [
	self assert: compilationTarget compilerObjectType isOpaqueType.
	self assert: compilationTarget compilerObjectType isCompilerObjectType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat16Type [
	| type |
	type := compilationTarget float16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 2.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat32Type [
	| type |
	type := compilationTarget float32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 4.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat32x2Type [
	| type |
	type := compilationTarget float32x2Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 8.
	self assert: type instanceAlignment equals: 8.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0}.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat32x3Type [
	| type |
	type := compilationTarget float32x3Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 12.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0 . 0.0}.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat32x4Type [
	| type |
	type := compilationTarget float32x4Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 16.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0 . 0.0 . 0.0}.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat64Type [
	| type |
	type := compilationTarget float64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 8.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat64x2Type [
	| type |
	type := compilationTarget float64x2Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 16.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0}.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat64x3Type [
	| type |
	type := compilationTarget float64x3Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 24.
	self assert: type instanceAlignment equals: 32.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0 . 0.0}.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFloat64x4Type [
	| type |
	type := compilationTarget float64x4Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 32.
	self assert: type instanceAlignment equals: 32.
	self assert: type defaultValue slotValues equals: {0.0 . 0.0 . 0.0 . 0.0}.
]

{ #category : #coercing }
MbndCompilationTargetTest >> testFloatCoercions [
	| float16Type float32Type float64Type |
	float16Type := compilationTarget float16Type.
	float32Type := compilationTarget float32Type.
	float64Type := compilationTarget float64Type.

	"Identity"
	self assert: (float16Type arithmeticCoercionWith: float16Type) equals: float16Type.
	self assert: (float32Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (float64Type arithmeticCoercionWith: float64Type) equals: float64Type.

	"Float16"
	self assert: (float16Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (float16Type arithmeticCoercionWith: float64Type) equals: float64Type.
	
	self assert: (float32Type arithmeticCoercionWith: float16Type) equals: float32Type.
	self assert: (float64Type arithmeticCoercionWith: float16Type) equals: float64Type.
	
	"Float32"
	self assert: (float32Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: float32Type) equals: float64Type.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFunction2Type [
	| type argumentType returnType |
	argumentType := compilationTarget uint8Type.
	returnType := compilationTarget voidType.
	type := argumentType => returnType.
	self assert: type isFunctionalType.
	self assert: type isFunctionType.
	self assert: type argumentTypes equals: {argumentType}.
	self assert: type returnType equals: returnType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFunctionTemplateType [
	self assert: compilationTarget functionTemplateType isTemplateType.
	self assert: compilationTarget functionTemplateType isFunctionTemplateType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testFunctionType [
	| type argumentTypes returnType |
	argumentTypes := {compilationTarget uint8Type . compilationTarget float32Type}.
	returnType := compilationTarget voidType.
	type := compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType.
	self assert: type isFunctionalType.
	self assert: type isFunctionType.
	self assert: type argumentTypes equals: argumentTypes.
	self assert: type returnType equals: returnType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testGCClassType [
	| classType classType2 |
	classType := compilationTarget createNamedType: #Test ofKind: MbndGCClassType.
	classType2 := compilationTarget createNamedType: #Test ofKind: MbndGCClassType.
	self assert: classType isAbstractClassType.
	self assert: classType isGCClassType.
	self assert: classType isGarbageCollectedType.
	self assert: classType2 isAbstractClassType.
	self assert: classType2 isGCClassType.
	self assert: classType ~~ classType2
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInputChannelType [
	| type messageType |
	messageType := compilationTarget uint32Type.
	type := messageType inputChannel.
	self assert: type isOpaqueType.
	self assert: type isOpaqueHandleType.
	self assert: type isIOChannelType.
	self assert: type isInputChannelType.
	self assert: type messageType equals: messageType.
	self assert: messageType inputChannel equals: type.
	self assert: type defaultValue unwrapMbndValue equals: nil.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt16Type [
	| type |
	type := compilationTarget int16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 2.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt32Type [
	| type |
	type := compilationTarget int32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 4.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt32x2Type [
	| type |
	type := compilationTarget int32x2Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 8.
	self assert: type instanceAlignment equals: 8.
	self assert: type defaultValue slotValues equals: #(0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt32x3Type [
	| type |
	type := compilationTarget int32x3Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 12.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: #(0 0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt32x4Type [
	| type |
	type := compilationTarget int32x4Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 16.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: #(0 0 0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt64Type [
	| type |
	type := compilationTarget int64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 8.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testInt8Type [
	| type |
	type := compilationTarget int8Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 1.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testIntPointerType [
	| type |
	type := compilationTarget intPointerType.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize >= 4.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #coercing }
MbndCompilationTargetTest >> testIntegerCoercions [
	| int8Type uint8Type int16Type uint16Type  int32Type uint32Type int64Type uint64Type |
	int8Type := compilationTarget int8Type.
	uint8Type := compilationTarget uint8Type.
	int16Type := compilationTarget int16Type.
	uint16Type := compilationTarget uint16Type.
	int32Type := compilationTarget int32Type.
	uint32Type := compilationTarget uint32Type.
	int64Type := compilationTarget int64Type.
	uint64Type := compilationTarget uint64Type.

	"With Int32"
	self assert: (int8Type arithmeticCoercionWith: int32Type) equals: int32Type.
	self assert: (int16Type arithmeticCoercionWith: int32Type) equals: int32Type.	
	self assert: (uint8Type arithmeticCoercionWith: int32Type) equals: int32Type.
	self assert: (uint16Type arithmeticCoercionWith: int32Type) equals: int32Type.	

	self assert: (int32Type arithmeticCoercionWith: int8Type) equals: int32Type.
	self assert: (int32Type arithmeticCoercionWith: int16Type) equals: int32Type.	
	self assert: (int32Type arithmeticCoercionWith: uint8Type) equals: int32Type.
	self assert: (int32Type arithmeticCoercionWith: uint16Type) equals: int32Type.	

	"With UInt32"
	self assert: (uint8Type arithmeticCoercionWith: uint32Type) equals: uint32Type.
	self assert: (uint16Type arithmeticCoercionWith: uint32Type) equals: uint32Type.	

	self assert: (uint32Type arithmeticCoercionWith: uint8Type) equals: uint32Type.
	self assert: (uint32Type arithmeticCoercionWith: uint16Type) equals: uint32Type.	

	"With Int64"
	self assert: (int8Type arithmeticCoercionWith: int64Type) equals: int64Type.
	self assert: (int16Type arithmeticCoercionWith: int64Type) equals: int64Type.	
	self assert: (int32Type arithmeticCoercionWith: int64Type) equals: int64Type.	
	self assert: (uint8Type arithmeticCoercionWith: int64Type) equals: int64Type.
	self assert: (uint16Type arithmeticCoercionWith: int64Type) equals: int64Type.
	self assert: (uint32Type arithmeticCoercionWith: int64Type) equals: int64Type.

	self assert: (int64Type arithmeticCoercionWith: int8Type) equals: int64Type.
	self assert: (int64Type arithmeticCoercionWith: int16Type) equals: int64Type.	
	self assert: (int64Type arithmeticCoercionWith: int32Type) equals: int64Type.	
	self assert: (int64Type arithmeticCoercionWith: uint8Type) equals: int64Type.
	self assert: (int64Type arithmeticCoercionWith: uint16Type) equals: int64Type.
	self assert: (int64Type arithmeticCoercionWith: uint32Type) equals: int64Type.

	"With UInt64"
	self assert: (uint8Type arithmeticCoercionWith: uint64Type) equals: uint64Type.
	self assert: (uint16Type arithmeticCoercionWith: uint64Type) equals: uint64Type.	
	self assert: (uint32Type arithmeticCoercionWith: uint64Type) equals: uint64Type.	

	self assert: (uint64Type arithmeticCoercionWith: uint8Type) equals: uint64Type.
	self assert: (uint64Type arithmeticCoercionWith: uint16Type) equals: uint64Type.	
	self assert: (uint64Type arithmeticCoercionWith: uint32Type) equals: uint64Type.	

]

{ #category : #coercing }
MbndCompilationTargetTest >> testIntegerFloatCoercions [
	| int8Type uint8Type int16Type uint16Type int32Type uint32Type int64Type uint64Type float16Type float32Type float64Type |
	int8Type := compilationTarget int8Type.
	uint8Type := compilationTarget uint8Type.
	int16Type := compilationTarget int16Type.
	uint16Type := compilationTarget uint16Type.
	int32Type := compilationTarget int32Type.
	uint32Type := compilationTarget uint32Type.
	int64Type := compilationTarget int64Type.
	uint64Type := compilationTarget uint64Type.
	float16Type := compilationTarget float16Type.
	float32Type := compilationTarget float32Type.
	float64Type := compilationTarget float64Type.

	"Float16"
	self assert: (uint8Type arithmeticCoercionWith: float16Type) equals: float16Type.
	self assert: (int8Type arithmeticCoercionWith: float16Type) equals: float16Type.
	self assert: (uint16Type arithmeticCoercionWith: float16Type) equals: float16Type.
	self assert: (int16Type arithmeticCoercionWith: float16Type) equals: float16Type.
	self assert: (uint32Type arithmeticCoercionWith: float16Type) equals: nil.
	self assert: (int32Type arithmeticCoercionWith: float16Type) equals: nil.
	self assert: (uint64Type arithmeticCoercionWith: float16Type) equals: nil.
	self assert: (int64Type arithmeticCoercionWith: float16Type) equals: nil.

	self assert: (float16Type arithmeticCoercionWith: uint8Type) equals: float16Type.
	self assert: (float16Type arithmeticCoercionWith: int8Type) equals: float16Type.
	self assert: (float16Type arithmeticCoercionWith: uint16Type) equals: float16Type.
	self assert: (float16Type arithmeticCoercionWith: int16Type) equals: float16Type.
	self assert: (float16Type arithmeticCoercionWith: uint32Type) equals: nil.
	self assert: (float16Type arithmeticCoercionWith: int32Type) equals: nil.
	self assert: (float16Type arithmeticCoercionWith: uint64Type) equals: nil.
	self assert: (float16Type arithmeticCoercionWith: int64Type) equals: nil.

	"Float32"
	self assert: (uint8Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (int8Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (uint16Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (int16Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (uint32Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (int32Type arithmeticCoercionWith: float32Type) equals: float32Type.
	self assert: (uint64Type arithmeticCoercionWith: float32Type) equals: float64Type.
	self assert: (int64Type arithmeticCoercionWith: float32Type) equals: float64Type.

	self assert: (float32Type arithmeticCoercionWith: uint8Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: int8Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: uint16Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: int16Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: uint32Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: int32Type) equals: float32Type.
	self assert: (float32Type arithmeticCoercionWith: uint64Type) equals: float64Type.
	self assert: (float32Type arithmeticCoercionWith: int64Type) equals: float64Type.

	"Float64"
	self assert: (uint8Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (int8Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (uint16Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (int16Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (uint32Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (int32Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (uint64Type arithmeticCoercionWith: float64Type) equals: float64Type.
	self assert: (int64Type arithmeticCoercionWith: float64Type) equals: float64Type.

	self assert: (float64Type arithmeticCoercionWith: uint8Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: int8Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: uint16Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: int16Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: uint32Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: int32Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: uint64Type) equals: float64Type.
	self assert: (float64Type arithmeticCoercionWith: int64Type) equals: float64Type.

]

{ #category : #coercing }
MbndCompilationTargetTest >> testLargerIntegerCoercions [
	| int32Type uint32Type int64Type uint64Type |
	int32Type := compilationTarget int32Type.
	uint32Type := compilationTarget uint32Type.
	int64Type := compilationTarget int64Type.
	uint64Type := compilationTarget uint64Type.

	"Signed/unsigned coercions."
	self assert: (int32Type arithmeticCoercionWith: int32Type) equals: int32Type.
	self assert: (uint32Type arithmeticCoercionWith: uint32Type) equals: uint32Type.

	self assert: (int64Type arithmeticCoercionWith: int64Type) equals: int64Type.
	self assert: (uint64Type arithmeticCoercionWith: uint64Type) equals: uint64Type.

	self assert: (int32Type arithmeticCoercionWith: uint32Type) equals: int64Type.
	self assert: (uint32Type arithmeticCoercionWith: int32Type) equals: int64Type.

	self assert: (uint32Type arithmeticCoercionWith: int32Type) equals: int64Type.
	self assert: (int32Type arithmeticCoercionWith: uint32Type) equals: int64Type.

	"Dangerous implicit coercion."
	self assert: (uint64Type arithmeticCoercionWith: int64Type) equals: nil.
	self assert: (int64Type arithmeticCoercionWith: uint64Type) equals: nil.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralArrayType [
	| type |
	type := compilationTarget literalArrayType.
	self assert: type isLiteralArrayType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralAssociationType [
	| type type2 |
	type := compilationTarget associationKey: compilationTarget literalIntegerType value: compilationTarget float32Type.
	type2 := compilationTarget literalIntegerType --> compilationTarget float32Type.
	
	self assert: type isLiteralAssociationType.
	self assert: type == type2.
	self assert: type == compilationTarget literalAssociationType.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralByteArrayType [
	| type |
	type := compilationTarget literalByteArrayType.
	self assert: type isLiteralByteArrayType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralFalseType [
	self assert: compilationTarget literalBooleanFalseType isLiteralBooleanType.
	self assert: compilationTarget literalBooleanFalseType isLiteralBooleanFalseType.
	self assert: (false mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalBooleanFalseType.
	
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralFloatType [
	self assert: compilationTarget literalFloatType isLiteralFloatType.
	self assert: (42.0 mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalFloatType.
	
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralIntegerType [
	self assert: compilationTarget literalIntegerType isLiteralIntegerType.
	self assert: (42 mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalIntegerType.
	
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralStringType [
	self assert: compilationTarget literalStringType isLiteralStringType.
	self assert: ('string' mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalStringType.
	
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralSymbolType [
	self assert: compilationTarget literalSymbolType isLiteralSymbolType.
	self assert: (#symbol mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalSymbolType.
	
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testLiteralTrueType [
	self assert: compilationTarget literalBooleanTrueType isLiteralBooleanType.
	self assert: compilationTarget literalBooleanTrueType isLiteralBooleanTrueType.
	self assert: (true mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalBooleanTrueType.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testMessageTemplateType [
	self assert: compilationTarget messageTemplateType isTemplateType.
	self assert: compilationTarget messageTemplateType isMessageTemplateType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testMetaBuilderInstanceType [
	self assert: compilationTarget metaBuilderInstanceType isMetaBuilderInstanceType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testMetaType [
	self assert: compilationTarget voidType type isMetaType.
	self assert: compilationTarget voidType type instanceType equals: compilationTarget voidType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testMethodTemplateType [
	self assert: compilationTarget methodTemplateType isTemplateType.
	self assert: compilationTarget methodTemplateType isMethodTemplateType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testNativeBlockClosureType [
	| type argumentTypes returnType |
	argumentTypes := {compilationTarget uint8Type . compilationTarget float32Type}.
	returnType := compilationTarget voidType.
	type := compilationTarget nativeBlockClosureTypeWithArguments: argumentTypes returnType: returnType.
	self assert: type isFunctionalType.
	self assert: type isBlockClosureType.
	self assert: type isNativeBlockClosureType.
	self assert: type argumentTypes equals: argumentTypes.
	self assert: type returnType equals: returnType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testNew [
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testOpaqueType [
	self assert: compilationTarget opaqueType isOpaqueType.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testOutputChannelType [
	| type messageType |
	messageType := compilationTarget uint32Type.
	type := messageType outputChannel.
	self assert: type isOpaqueType.
	self assert: type isOpaqueHandleType.
	self assert: type isIOChannelType.
	self assert: type isOutputChannelType.
	self assert: type messageType equals: messageType.
	self assert: messageType outputChannel equals: type.
	self assert: type defaultValue unwrapMbndValue equals: nil.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testPointerSize [
	self assert: compilationTarget pointerSize isInteger.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testPointerType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType pointer.
	self assert: type isDerivedType.
	self assert: type isPointerType.
	self assert: type baseType equals: baseType.
	self assert: baseType pointer equals: type.
	self assert: type defaultValue unwrapMbndValue equals: nil.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testReferenceType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType ref.
	self assert: type isDerivedType.
	self assert: type isReferenceType.
	self assert: type baseType equals: baseType.
	self assert: baseType ref equals: type.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testReturnType [
	self assert: compilationTarget returnType isOpaqueType.
	self assert: compilationTarget returnType isVoidType.
	self assert: compilationTarget returnType isReturnType.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testShortCircuit [
	self assert: compilationTarget basicType type supertype equals: compilationTarget behaviorType
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testSimpleMetaType [
	self assert: compilationTarget simpleMetaType isMetaType
]

{ #category : #coercing }
MbndCompilationTargetTest >> testSmallIntegerCoercions [
	| int8Type uint8Type int16Type uint16Type int32Type|
	int8Type := compilationTarget int8Type.
	uint8Type := compilationTarget uint8Type.
	int16Type := compilationTarget int16Type.
	uint16Type := compilationTarget uint16Type.
	int32Type := compilationTarget int32Type.

	self assert: (int8Type arithmeticCoercionWith: int8Type) equals: int32Type.
	self assert: (uint8Type arithmeticCoercionWith: uint8Type) equals: int32Type.
	self assert: (int8Type arithmeticCoercionWith: uint8Type) equals: int32Type.
	self assert: (uint8Type arithmeticCoercionWith: int8Type) equals: int32Type.

	self assert: (int16Type arithmeticCoercionWith: int16Type) equals: int32Type.
	self assert: (uint16Type arithmeticCoercionWith: uint16Type) equals: int32Type.
	self assert: (int16Type arithmeticCoercionWith: uint16Type) equals: int32Type.
	self assert: (int16Type arithmeticCoercionWith: uint16Type) equals: int32Type.
	
	self assert: (int8Type arithmeticCoercionWith: int16Type) equals: int32Type.
	self assert: (uint8Type arithmeticCoercionWith: int16Type) equals: int32Type.
	self assert: (int8Type arithmeticCoercionWith: uint16Type) equals: int32Type.
	self assert: (uint8Type arithmeticCoercionWith: uint16Type) equals: int32Type.

	self assert: (int16Type arithmeticCoercionWith: int8Type) equals: int32Type.
	self assert: (int16Type arithmeticCoercionWith: uint8Type) equals: int32Type.
	self assert: (uint16Type arithmeticCoercionWith: int8Type) equals: int32Type.
	self assert: (uint16Type arithmeticCoercionWith: uint8Type) equals: int32Type.

	self assert: (uint16Type arithmeticCoercionWith: int16Type) equals: int32Type.
	self assert: (int16Type arithmeticCoercionWith: uint16Type) equals: int32Type.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testStructureType [
	| structureType structureType2 |
	structureType := compilationTarget createNamedType: #Test ofKind: MbndStructureType.
	structureType2 := compilationTarget createNamedType: #Test ofKind: MbndStructureType.
	self assert: structureType isStructureType.
	self assert: structureType2 isStructureType.
	self assert: structureType ~~ structureType2
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testTemplateType [
	self assert: compilationTarget templateType isTemplateType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testTemporaryReferenceType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType tempRef.
	self assert: type isDerivedType.
	self assert: type isTemporaryReferenceType.
	self assert: type baseType equals: baseType.
	self assert: baseType tempRef equals: type.

]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testTupleType [
	| type type2 |
	type := compilationTarget tuple: {compilationTarget int32Type . compilationTarget int64Type}.
	type2 := compilationTarget int32Type , compilationTarget int64Type.
	
	self assert: type isTupleType.
	self assert: type equals: type2.
	self assert: type instanceSize equals: 16.
	self assert: type instanceAlignment equals: 8.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testTypeTemplateType [
	self assert: compilationTarget typeTemplateType isTypeTemplateType.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt16Type [
	| type |
	type := compilationTarget uint16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 2.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt32Type [
	| type |
	type := compilationTarget uint32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 4.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt32x2Type [
	| type |
	type := compilationTarget uint32x2Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 8.
	self assert: type instanceAlignment equals: 8.
	self assert: type defaultValue slotValues equals: #(0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt32x3Type [
	| type |
	type := compilationTarget uint32x3Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 12.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: #(0 0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt32x4Type [
	| type |
	type := compilationTarget uint32x4Type.
	self assert: type isPrimitiveVectorType.
	self assert: type instanceSize equals: 16.
	self assert: type instanceAlignment equals: 16.
	self assert: type defaultValue slotValues equals: #(0 0 0 0).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt64Type [
	| type |
	type := compilationTarget uint64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 8.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUInt8Type [
	| type |
	type := compilationTarget uint8Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self deny: type isPrimitiveCharacterCodeType.
	self assert: type valueSize equals: 1.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUIntPointerType [
	| type |
	type := compilationTarget uintPointerType.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize >= 4.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUnboundedArrayType [
	| elementType type|
	elementType := compilationTarget uint8Type.
	type := elementType array.
	self assert: type isArrayType.
	self assert: type elementType equals: elementType.
	self assert: type elements equals: 0.
	self assert: type instanceSize equals: 0.
	self assert: type instanceAlignment equals: 1.
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUndefinedType [
	self assert: compilationTarget undefinedType isOpaqueType.
	self assert: compilationTarget undefinedType isUndefinedType.
	self assert: compilationTarget undefinedType defaultValue unwrapMbndValue equals: nil.
	
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testUnionType [
	| unionType unionType2 |
	unionType := compilationTarget createNamedType: #Test ofKind: MbndUnionType.
	unionType2 := compilationTarget createNamedType: #Test ofKind: MbndUnionType.
	self assert: unionType isUnionType.
	self assert: unionType2 isUnionType.
	self assert: unionType ~~ unionType2
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testVariantUnionType [
	| type |
	type := compilationTarget uint8Type | compilationTarget uint16Type.
	self assert: type isVariantUnionType.
	self assert: (type components includes: compilationTarget uint8Type).
	self assert: (type components includes: compilationTarget uint16Type).
]

{ #category : #'basic types' }
MbndCompilationTargetTest >> testVoidType [
	self assert: compilationTarget voidType isOpaqueType.
	self assert: compilationTarget voidType isVoidType.
	
]
