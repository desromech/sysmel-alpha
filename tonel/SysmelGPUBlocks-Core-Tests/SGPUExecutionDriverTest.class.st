"
A SGPUExecutionDriverTest is a test class for testing the behavior of SGPUExecutionDriver
"
Class {
	#name : #SGPUExecutionDriverTest,
	#superclass : #TestCase,
	#category : #'SysmelGPUBlocks-Core-Tests-Driver'
}

{ #category : #'as yet unclassified' }
SGPUExecutionDriverTest >> executionDriverClass [
	^ SGPUCPUExecutionDriver
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriverTest >> setUp [
	SGPUCompilationEnvironment reset.
	SGPUExecutionDriver current: self executionDriverClass new.
]

{ #category : #'as yet unclassified' }
SGPUExecutionDriverTest >> tearDown [
	SGPUCompilationEnvironment reset.
	SGPUExecutionDriver reset.
]

{ #category : #tests }
SGPUExecutionDriverTest >> testArrayCollect [
	| cpuBlock gpuBlock data result expectedResult |
	cpuBlock := [ :x | (x + 10) * 2 ].
	gpuBlock := cpuBlock gpuType: #(Float32 => Float32).
	data := ((1 to: 1234) collect: #asFloat) asGPUFloat32Array.
	result := data collect: gpuBlock.
	expectedResult := (1 to: 1234) collect: cpuBlock.
	self assert: result asArray equals: expectedResult
]
