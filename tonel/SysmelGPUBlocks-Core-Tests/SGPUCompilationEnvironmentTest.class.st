"
A SGPUCompilationEnvironmentTest is a test class for testing the behavior of SGPUCompilationEnvironment
"
Class {
	#name : #SGPUCompilationEnvironmentTest,
	#superclass : #TestCase,
	#instVars : [
		'compilationEnvironment'
	],
	#category : #'SysmelGPUBlocks-Core-Tests-Compilation'
}

{ #category : #running }
SGPUCompilationEnvironmentTest >> setUp [
	SGPUCompilationEnvironment reset.
]

{ #category : #running }
SGPUCompilationEnvironmentTest >> tearDown [
	SGPUCompilationEnvironment reset.
]

{ #category : #tests }
SGPUCompilationEnvironmentTest >> testLiteralArrayTypeExpression [
	| type |
	type := compilationEnvironment evaluateTypeExpression: #Float32.
	self assert: type isPrimitiveFloatType.
	self assert: type instanceSize equals: 4.

	type := compilationEnvironment evaluateTypeExpression: #().
	self assert: type isTupleType.
	self assert: type elements isEmpty.
	self assert: type elements size equals: 0.
	
	type := compilationEnvironment evaluateTypeExpression: #(Float32 pointer).
	self assert: type isPointerType.
	self assert: type baseType isPrimitiveFloatType.
	self assert: type baseType instanceSize equals: 4.

	type := compilationEnvironment evaluateTypeExpression: #(Float32, Int32).
	self assert: type isTupleType.
	self assert: type elements size equals: 2.
	self assert: type elements first isPrimitiveFloatType.
	self assert: type elements first instanceSize equals: 4.
	self assert: type elements second isPrimitiveIntegerType.
	self assert: type elements second instanceSize equals: 4.
]

{ #category : #tests }
SGPUCompilationEnvironmentTest >> testStringTypeExpression [
	| type |
	type := compilationEnvironment evaluateTypeExpression: 'Float32'.
	self assert: type isPrimitiveFloatType.
	self assert: type instanceSize equals: 4.
	
	type := compilationEnvironment evaluateTypeExpression: 'Float32 pointer'.
	self assert: type isPointerType.
	self assert: type baseType isPrimitiveFloatType.
	self assert: type baseType instanceSize equals: 4.

	type := compilationEnvironment evaluateTypeExpression: 'Float32, Int32'.
	self assert: type isTupleType.
	self assert: type elements size equals: 2.
	self assert: type elements first isPrimitiveFloatType.
	self assert: type elements first instanceSize equals: 4.
	self assert: type elements second isPrimitiveIntegerType.
	self assert: type elements second instanceSize equals: 4.

]
