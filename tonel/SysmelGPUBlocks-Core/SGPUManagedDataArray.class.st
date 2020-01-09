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
SGPUManagedDataArray >> binaryReductionWith: aBinaryBlock [
	| neutralValue |
	neutralValue := mbndType defaultValue value.
	^ self binaryReductionWith: aBinaryBlock neutralValue: neutralValue
]

{ #category : #enumerating }
SGPUManagedDataArray >> binaryReductionWith: aBinaryBlock neutralValue: neutralValue [
	| shaderStageCode stageReductionSize currentReductionSize nextReductionSize pingBuffer pongBuffer tempBuffer quickConstants neutralValueOffset |
	aBinaryBlock isSGPUBlockClosure ifFalse: [ self halt ].
	
	shaderStageCode := aBinaryBlock asBinaryReductionShaderStageCode.
	self ensureInGPU.
	
	stageReductionSize := 2 * shaderStageCode localBlockSize.
	
	currentReductionSize := self size.
	pingBuffer := self.
	pongBuffer := nil.
	neutralValueOffset := 4 alignedTo: mbndType instanceAlignment.
	quickConstants := ByteArray new: neutralValueOffset + mbndType instanceSize.
	cpuData elementType write: neutralValue intoPointer: (SLVMInternalObjectPointer object: quickConstants offset: neutralValueOffset).
	
	[currentReductionSize > 1] whileTrue: [ 
		nextReductionSize := (currentReductionSize + stageReductionSize - 1) // stageReductionSize max: 1.

		(pongBuffer isNil or: [nextReductionSize = 1]) ifTrue: [
			pongBuffer := compilationEnvironment constructArrayOfType: aBinaryBlock returnType withSize: nextReductionSize
		].
	
		"Enqueue the computation"
		self enqueueBinaryReductionFrom: currentReductionSize buffer: pingBuffer to: nextReductionSize buffer: pongBuffer
			shaderStage: shaderStageCode quickConstants: quickConstants.
		
		"Swap the ping-pong buffers"
		tempBuffer := pingBuffer ~~ self ifTrue: [pingBuffer] ifFalse: [nil].
		pingBuffer := pongBuffer.
		pongBuffer := tempBuffer.
		currentReductionSize := nextReductionSize
	].

	^ pingBuffer
]

{ #category : #accessing }
SGPUManagedDataArray >> byteSize [
	^ cpuData rawDataSize
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

{ #category : #enumerating }
SGPUManagedDataArray >> enqueueBinaryReductionFrom: sourceSize buffer: sourceBuffer to: targetSize buffer: targetBuffer
shaderStage: shaderStageCode quickConstants: quickConstants [
	quickConstants unsignedLongAt: 1 put: sourceSize.
	
	SGPUExecutionDriver current
		enqueueComputationWithInputBuffers: { sourceBuffer } outputBuffers: { targetBuffer }
		pushConstants: quickConstants
		computeShaderStage: shaderStageCode globalSize: (sourceSize + 1) // 2
		cpuFallbackWith: [
			self halt
		].
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
