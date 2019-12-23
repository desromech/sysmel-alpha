Class {
	#name : #SGPUManagedDataArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'size',
		'mbndType',
		'cpuData',
		'currentDataLocation',
		'gpuBufferHandle'
	],
	#category : #'SysmelGPUBlocks-Core-Data'
}

{ #category : #adding }
SGPUManagedDataArray >> add: newObject [
	self shouldNotImplement
]

{ #category : #converting }
SGPUManagedDataArray >> asArray [
	self ensureInCPU.
	^ cpuData asArray
]

{ #category : #converting }
SGPUManagedDataArray >> asFloatArray [
	self ensureInCPU.
	^ cpuData asFloatArray
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index [
	self ensureInCPU.
	^ cpuData at: index
]

{ #category : #accessing }
SGPUManagedDataArray >> at: index put: value [
	self ensureInCPU.
	^ cpuData at: index put: value
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
SGPUManagedDataArray >> cpuData [
	^ cpuData
]

{ #category : #accessing }
SGPUManagedDataArray >> currentDataLocation [
	^ currentDataLocation
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> ensureInCPU [
	self isInCPU ifTrue: [ ^ self ].
	SGPUExecutionDriver current ensureManagedDataArrayIsInCPU: self
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> ensureInGPU [
	self isInGPU ifTrue: [ ^ self ].
	SGPUExecutionDriver current ensureManagedDataArrayIsInGPU: self
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

{ #category : #testing }
SGPUManagedDataArray >> isInCPU [
	^ #(both cpu) includes: currentDataLocation
]

{ #category : #testing }
SGPUManagedDataArray >> isInGPU [
	^ #(both gpu) includes: currentDataLocation
]

{ #category : #'as yet unclassified' }
SGPUManagedDataArray >> markSynchronizedCopies [
	currentDataLocation := #both
]

{ #category : #accessing }
SGPUManagedDataArray >> mbndType [
	^ mbndType
]

{ #category : #accessing }
SGPUManagedDataArray >> size [
	^ size
]

{ #category : #private }
SGPUManagedDataArray >> species [
	^ Array
]
