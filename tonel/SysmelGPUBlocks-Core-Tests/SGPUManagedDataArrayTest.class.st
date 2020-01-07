Class {
	#name : #SGPUManagedDataArrayTest,
	#superclass : #TestCase,
	#category : #'SysmelGPUBlocks-Core-Tests-Compilation'
}

{ #category : #running }
SGPUManagedDataArrayTest >> setUp [
	SGPUCompilationEnvironment reset.
]

{ #category : #running }
SGPUManagedDataArrayTest >> tearDown [
	SGPUCompilationEnvironment reset.
]

{ #category : #tests }
SGPUManagedDataArrayTest >> testAsGPUFloat32Array [
	| array |
	array := #(0.0 1.0 2.0 3.0) asGPUFloat32Array.
	self assert: array size equals: 4.
	self assert: array mbndType isPrimitiveFloatType.
	self assert: array mbndType instanceSize equals: 4.
	self assert: array isInCPU.
	self assert: array asArray equals: #(0.0 1.0 2.0 3.0).
]

{ #category : #tests }
SGPUManagedDataArrayTest >> testIntervalAsGPUFloat32Array [
	| array |
	array := (0 to: 4) asGPUFloat32Array.
	self assert: array size equals: 5.
	self assert: array mbndType isPrimitiveFloatType.
	self assert: array mbndType instanceSize equals: 4.
	self assert: array isNotYetGenerated.
	
	"This must invoke the generator and send the data into the CPU."
	self assert: array asArray equals: #(0.0 1.0 2.0 3.0 4.0).
	
	self deny: array isNotYetGenerated.
	self assert: array isInCPU.
	self deny: array isInGPU.
]
