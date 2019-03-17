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
	#category : #'MoebiusBandMetamodel-Core-Tests-CompilationTarget'
}

{ #category : #testing }
MbndCompilationTargetTest class >> isAbstract [
	^ self == MbndCompilationTargetTest
]

{ #category : #tests }
MbndCompilationTargetTest >> testBooleanType [
	| type |
	type := compilationTarget booleanType.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveBooleanType.
	self assert: type valueSize equals: 1.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat16Type [
	| type |
	type := compilationTarget float16Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 2.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat32Type [
	| type |
	type := compilationTarget float32Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 4.
]

{ #category : #tests }
MbndCompilationTargetTest >> testFloat64Type [
	| type |
	type := compilationTarget float64Type.
	self assert: type isPrimitiveType.
	self assert: type isPrimitiveFloatType.
	self assert: type valueSize equals: 8.
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
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testNew [
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testPointerSize [
	self assert: compilationTarget pointerSize isInteger.
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
	
]

{ #category : #tests }
MbndCompilationTargetTest >> testVoidType [
	self assert: compilationTarget voidType isVoidType.
	
]
