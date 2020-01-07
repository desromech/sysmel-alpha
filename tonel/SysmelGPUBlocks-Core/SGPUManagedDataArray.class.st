Class {
	#name : #SGPUManagedDataArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'compilationEnvironment',
		'size',
		'mbndType',
		'cpuData',
		'currentDataLocation',
		'gpuBufferHandle',
		'generator'
	],
	#category : #'SysmelGPUBlocks-Core-Data'
}

{ #category : #adding }
SGPUManagedDataArray >> add: newObject [
	self shouldNotImplement
]

{ #category : #converting }
SGPUManagedDataArray >> asArray [
	^ self cpuData asArray
]

{ #category : #converting }
SGPUManagedDataArray >> asFloatArray [
	^ self cpuData asFloatArray
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index [
	^ self cpuData at: index
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index put: value [
	^ self cpuData at: index put: value
]

{ #category : #enumerating }
SGPUManagedDataArray >> collect: aBlock [
	| shaderStageCode resultBuffer |
	aBlock isSGPUBlockClosure ifFalse: [ ^ super collect: aBlock ].
	
	shaderStageCode := aBlock asCollectionMapShaderStageCode.
	self ensureInGPU.

	resultBuffer := SGPUCompilationEnvironment current	
		constructArrayOfType: aBlock returnType withSize: self size.
	SGPUExecutionDriver current
		enqueueComputationWithInputBuffers: { self } outputBuffers: { resultBuffer }
		pushConstants: (IntegerArray with: size)
		computeShaderStage: shaderStageCode globalSize: size
		cpuFallbackWith: [
			1 to: size do: [ :i |
				resultBuffer at: i put: (aBlock value: (self at: i))
			]
		].
	
	^ resultBuffer
]

{ #category : #accessing }
SGPUManagedDataArray >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
SGPUManagedDataArray >> compilationEnvironment: anObject [
	compilationEnvironment := anObject
]

{ #category : #accessing }
SGPUManagedDataArray >> cpuData [
	self ensureInCPU.
	^ cpuData
]

{ #category : #accessing }
SGPUManagedDataArray >> currentDataLocation [
	^ currentDataLocation
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> ensureInCPU [
	self isInCPU ifTrue: [ ^ self ].
	self isNotYetGenerated ifTrue: [ ^ self generateDataInCPU ].
	SGPUExecutionDriver current ensureManagedDataArrayIsInCPU: self
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> ensureInGPU [
	self isInGPU ifTrue: [ ^ self ].
	SGPUExecutionDriver current ensureManagedDataArrayIsInGPU: self
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> generateDataInCPU [
	self assert: generator isNotNil.
	self markOnlyValidInCPU.
	
	generator generateDataWithSize: self size intoCPUBuffer: cpuData.
	
	generator := nil.
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> generateDataInGPU [
	self assert: generator isNotNil.
	generator generateDataInGPUManagedBuffer: self.
	generator := nil.
]

{ #category : #accessing }
SGPUManagedDataArray >> generator [
	^ generator
]

{ #category : #accessing }
SGPUManagedDataArray >> gpuBufferHandle [
	^ gpuBufferHandle
]

{ #category : #accessing }
SGPUManagedDataArray >> gpuBufferHandle: anObject [
	gpuBufferHandle := anObject
]

{ #category : #initialization }
SGPUManagedDataArray >> initializeForType: aMbndType withCPUData: theCpuData [
	mbndType := aMbndType.
	cpuData := theCpuData.
	currentDataLocation := #cpu.
	size := theCpuData size.
]

{ #category : #initialization }
SGPUManagedDataArray >> initializeForType: aMbndType withGenerator: theGenerator cpuAllocationData: theCpuData [
	mbndType := aMbndType.
	cpuData := theCpuData.
	currentDataLocation := #notYetGenerated.
	size := theCpuData size.
	generator := theGenerator.
]

{ #category : #testing }
SGPUManagedDataArray >> isInCPU [
	^ #(both cpu) includes: currentDataLocation
]

{ #category : #testing }
SGPUManagedDataArray >> isInGPU [
	^ #(both gpu) includes: currentDataLocation
]

{ #category : #testing }
SGPUManagedDataArray >> isNotYetGenerated [
	^ currentDataLocation == #notYetGenerated
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> markOnlyValidInCPU [
	currentDataLocation := #cpu.
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> markOnlyValidInGPU [
	currentDataLocation := #gpu.
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> markSynchronizedCopies [
	currentDataLocation := #both.
	generator := nil.
]

{ #category : #accessing }
SGPUManagedDataArray >> mbndType [
	^ mbndType
]

{ #category : #accessing }
SGPUManagedDataArray >> rawCpuData [
	^ cpuData
]

{ #category : #accessing }
SGPUManagedDataArray >> size [
	^ size
]

{ #category : #private }
SGPUManagedDataArray >> species [
	^ Array
]
