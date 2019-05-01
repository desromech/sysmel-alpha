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

{ #category : #tests }
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

{ #category : #tests }
MbndCompilationTargetTest >> testBooleanType [
	| type |
	type := compilationTarget booleanType.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveBooleanType.
	self assert: type valueSize equals: 1.
	self assert: type defaultValue unwrapMbndValue equals: false.
]

{ #category : #tests }
MbndCompilationTargetTest >> testCStringLiteralType [
	| type |
	type := compilationTarget cstringLiteralType.
	self assert: type isPointerType.
	self assert: type baseType isConstantType.
	self assert: type baseType baseType isPrimitiveIntegerType.
	self assert: type baseType baseType instanceSize equals: 1.
]

{ #category : #tests }
MbndCompilationTargetTest >> testCompilerObjectType [
	self assert: compilationTarget compilerObjectType isOpaqueType.
	self assert: compilationTarget compilerObjectType isCompilerObjectType.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat16Type [
	| type |
	type := compilationTarget float16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 2.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat32Type [
	| type |
	type := compilationTarget float32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 4.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat64Type [
	| type |
	type := compilationTarget float64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 8.
	self assert: type defaultValue unwrapMbndValue equals: 0.0.
]

{ #category : #tests }
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

{ #category : #tests }
MbndCompilationTargetTest >> testInt16Type [
	| type |
	type := compilationTarget int16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 2.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
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

{ #category : #tests }
MbndCompilationTargetTest >> testInt64Type [
	| type |
	type := compilationTarget int64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 8.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testInt8Type [
	| type |
	type := compilationTarget int8Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 1.
	self assert: type isSigned.
	self deny: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralFalseType [
	self assert: compilationTarget literalBooleanFalseType isLiteralBooleanType.
	self assert: compilationTarget literalBooleanFalseType isLiteralBooleanFalseType.
	self assert: (false mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalBooleanFalseType.
	
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralFloatType [
	self assert: compilationTarget literalFloatType isLiteralFloatType.
	self assert: (42.0 mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalFloatType.
	
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralIntegerType [
	self assert: compilationTarget literalIntegerType isLiteralIntegerType.
	self assert: (42 mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalIntegerType.
	
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralStringType [
	self assert: compilationTarget literalStringType isLiteralStringType.
	self assert: ('string' mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalStringType.
	
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralSymbolType [
	self assert: compilationTarget literalSymbolType isLiteralSymbolType.
	self assert: (#symbol mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalSymbolType.
	
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testLiteralTrueType [
	self assert: compilationTarget literalBooleanTrueType isLiteralBooleanType.
	self assert: compilationTarget literalBooleanTrueType isLiteralBooleanTrueType.
	self assert: (true mbndLiteralTypeWithTarget: compilationTarget) equals: compilationTarget literalBooleanTrueType.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testMetaBuilderInstanceType [
	self assert: compilationTarget metaBuilderInstanceType isMetaBuilderInstanceType.
]

{ #category : #tests }
MbndCompilationTargetTest >> testMetaType [
	self assert: compilationTarget voidType type isMetaType.
	self assert: compilationTarget voidType type instanceType equals: compilationTarget voidType.
]

{ #category : #tests }
MbndCompilationTargetTest >> testNew [
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testOpaqueType [
	self assert: compilationTarget opaqueType isOpaqueType.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testPointerSize [
	self assert: compilationTarget pointerSize isInteger.
]

{ #category : #tests }
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

{ #category : #tests }
MbndCompilationTargetTest >> testReferenceType [
	| type baseType |
	baseType := compilationTarget uint8Type.
	type := baseType ref.
	self assert: type isDerivedType.
	self assert: type isReferenceType.
	self assert: type baseType equals: baseType.
	self assert: baseType ref equals: type.

]

{ #category : #tests }
MbndCompilationTargetTest >> testReturnType [
	self assert: compilationTarget returnType isOpaqueType.
	self assert: compilationTarget returnType isVoidType.
	self assert: compilationTarget returnType isReturnType.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testUInt16Type [
	| type |
	type := compilationTarget uint16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 2.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testUInt32Type [
	| type |
	type := compilationTarget uint32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 4.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testUInt64Type [
	| type |
	type := compilationTarget uint64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 8.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testUInt8Type [
	| type |
	type := compilationTarget uint8Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveIntegerType.
	self assert: type valueSize equals: 1.
	self deny: type isSigned.
	self assert: type isUnsigned.
	self assert: type defaultValue unwrapMbndValue equals: 0.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testUndefinedType [
	self assert: compilationTarget undefinedType isOpaqueType.
	self assert: compilationTarget undefinedType isUndefinedType.
	self assert: compilationTarget undefinedType defaultValue unwrapMbndValue equals: nil.
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testVoidType [
	self assert: compilationTarget voidType isOpaqueType.
	self assert: compilationTarget voidType isVoidType.
	
]
