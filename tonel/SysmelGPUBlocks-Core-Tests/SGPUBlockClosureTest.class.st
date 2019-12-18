"
A SGPUBlockClosureTest is a test class for testing the behavior of SGPUBlockClosure
"
Class {
	#name : #SGPUBlockClosureTest,
	#superclass : #TestCase,
	#category : #'SysmelGPUBlocks-Core-Tests-Blocks'
}

{ #category : #running }
SGPUBlockClosureTest >> setUp [
	SGPUCompilationEnvironment reset.
]

{ #category : #running }
SGPUBlockClosureTest >> tearDown [
	SGPUCompilationEnvironment reset.
]

{ #category : #tests }
SGPUBlockClosureTest >> testFloatFunctionBlock [
	| block |
	block := [ :x | (x + 10) * 2 ] gpuType: #(Float32 => Float32).
	self assert: block functionType isFunctionType.
	self assert: block functionType argumentTypes size equals: 1.
	self assert: block functionType argumentTypes first isPrimitiveFloatType.
	self assert: block functionType returnType isPrimitiveFloatType.
	self assert: (block value: 5) equals: 30
]

{ #category : #tests }
SGPUBlockClosureTest >> testFloatLiteralBlock [
	| block |
	block := [ 42.5 ] gpuType: #(() => Float32).
	self assert: block functionType isFunctionType.
	self assert: block functionType argumentTypes size equals: 0.
	self assert: block functionType returnType isPrimitiveFloatType.
	self assert: block value equals: 42.5
]

{ #category : #tests }
SGPUBlockClosureTest >> testIntegerLiteralBlock [
	| block |
	block := [ 1 ] gpuType: #(() => Int32).
	self assert: block functionType isFunctionType.
	self assert: block functionType argumentTypes size equals: 0.
	self assert: block functionType returnType isPrimitiveIntegerType.
	
	self assert: block value equals: 1
]
