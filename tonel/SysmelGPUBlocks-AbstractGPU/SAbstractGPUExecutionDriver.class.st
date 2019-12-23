Class {
	#name : #SAbstractGPUExecutionDriver,
	#superclass : #SGPUExecutionDriver,
	#instVars : [
		'device',
		'gpuBufferHandleMap',
		'computeShaderSignature',
		'computePipelineStateHandleMap',
		'spirVModuleHandleMap',
		'computationCommandQueue',
		'computationCommandAllocator',
		'computationCommandList',
		'isComputationCommandListOpen',
		'hasPendingComputations',
		'freeShaderResourceBindings',
		'occupiedShaderResourceBindings'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'SysmelGPUBlocks-AbstractGPU'
}

{ #category : #testing }
SAbstractGPUExecutionDriver class >> isAvailable [
	| mainPlatform |
	mainPlatform := AGPU mainPlatform.
	^ mainPlatform isNotNil and: [mainPlatform isNull not]
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> computePipelineStateForStage: shaderStage [
	^ computePipelineStateHandleMap at: shaderStage ifAbsentPut: [
		| builder |
		builder := device createComputePipelineBuilder.
		builder
			setShaderSignature: computeShaderSignature;
			attachShaderWithEntryPoint: (self shaderLibraryForSpirVModule: shaderStage spirVModule)
				type: AGPU_COMPUTE_SHADER
				entry_point: shaderStage entryPointName asString;
			build.
	]
]

{ #category : #initialization }
SAbstractGPUExecutionDriver >> createShaderSignature [
	| builder |
	builder := device createShaderSignatureBuilder.
	builder
		beginBindingBank: 1000;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER bindingPointCount: 2;
		"bufferSize" addBindingConstant.
	computeShaderSignature := builder build
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> enqueueComputationWithInputBuffers: inputManagedBuffers outputBuffers: outputManagedBuffers pushConstants: pushConstant
computeShaderStage: shaderStageCode globalGridSize: gridSize
cpuFallbackWith: cpuFallbackBlock [

	| pipelineState shaderResourceBinding destBufferIndex |
	shaderResourceBinding := self getFreeComputeArgumentShaderResourceBinding.
	pipelineState := self computePipelineStateForStage: shaderStageCode.

	self ensureValidComputationCommandList.
	computationCommandList usePipelineState: pipelineState.
	
	"Bind the input buffers."
	destBufferIndex := 0.
	inputManagedBuffers do: [ :managedBuffer |
		shaderResourceBinding bindStorageBuffer: destBufferIndex storage_buffer: (self validStorageBufferHandleFor: managedBuffer).
		destBufferIndex := destBufferIndex + 1
	].
	
	"Bind the output buffers."
	outputManagedBuffers do: [ :managedBuffer |
		shaderResourceBinding bindStorageBuffer: destBufferIndex storage_buffer: (self validStorageBufferHandleFor: managedBuffer).
		managedBuffer markOnlyValidInGPU.
		destBufferIndex := destBufferIndex + 1
	].

	"Use the buffer arguments."
	computationCommandList useComputeShaderResources: shaderResourceBinding.
	
	"Pass the push constants"
	pushConstant ifNotNil: [ 
		pushConstant pushAsGPUConstantsWithCommandList: computationCommandList at: 0.
	].

	"Dispatch the computation."
	computationCommandList dispatchCompute: gridSize first group_count_y: gridSize second group_count_z: gridSize third.
	
	hasPendingComputations := true.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> ensureBufferIsReadyForDeviceToHostTransfer: buffer [
	self finishPendingComputations.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> ensureBufferIsReadyForHostToDeviceTransfer: buffer [
	self finishPendingComputations.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> ensureManagedDataArrayIsInCPU: managedDataArray [
	| bufferHandle rawCpuData |
	bufferHandle := self validStorageBufferHandleFor: managedDataArray.
	self ensureBufferIsReadyForDeviceToHostTransfer: bufferHandle.
	
	rawCpuData := managedDataArray rawCpuData.
	bufferHandle readBufferData: 0 size: rawCpuData rawDataSize data: rawCpuData rawData.
	managedDataArray markSynchronizedCopies
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> ensureManagedDataArrayIsInGPU: managedDataArray [
	| bufferHandle rawCpuData |
	bufferHandle := self validStorageBufferHandleFor: managedDataArray.
	self ensureBufferIsReadyForHostToDeviceTransfer: bufferHandle.

	rawCpuData := managedDataArray rawCpuData.
	bufferHandle uploadBufferData: 0 size: rawCpuData rawDataSize data: rawCpuData rawData.
	managedDataArray markSynchronizedCopies
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> ensureValidComputationCommandList [
	isComputationCommandListOpen ifTrue: [ ^ self ].
	self finishPendingComputations.
	
	computationCommandAllocator reset.
	computationCommandList reset: computationCommandAllocator initial_pipeline_state: nil.
	isComputationCommandListOpen := true.
	computationCommandList
		setShaderSignature: computeShaderSignature.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> finishPendingComputations [
	hasPendingComputations ifFalse: [ ^ self ].
	self flushPendingComputations.
	device finishExecution.
	self freeOcuppiedShaderResourceBindings
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> flushPendingComputations [
	isComputationCommandListOpen ifFalse: [ ^ false ].
	computationCommandList close.

	isComputationCommandListOpen := false.
	hasPendingComputations ifTrue: [
		computationCommandQueue addCommandList: computationCommandList
	].
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> freeOcuppiedShaderResourceBindings [
	freeShaderResourceBindings addAll: occupiedShaderResourceBindings.
	occupiedShaderResourceBindings removeAll
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> getFreeComputeArgumentShaderResourceBinding [
	| result |
	freeShaderResourceBindings ifEmpty: [ 
		result := computeShaderSignature createShaderResourceBinding: 0.
	] ifNotEmpty: [ 
		result := freeShaderResourceBindings last.
		freeShaderResourceBindings removeLast
	].
	occupiedShaderResourceBindings add: result.
	^ result
]

{ #category : #initialization }
SAbstractGPUExecutionDriver >> initialize [
	super initialize.
	device := AGPU mainDevice.
	gpuBufferHandleMap := WeakIdentityKeyDictionary new.
	computePipelineStateHandleMap := WeakIdentityKeyDictionary new.
	spirVModuleHandleMap := WeakIdentityKeyDictionary new.
	freeShaderResourceBindings := OrderedCollection new.
	occupiedShaderResourceBindings := OrderedCollection new.
	self createShaderSignature.
	
	computationCommandQueue := device getDefaultCommandQueue.
	computationCommandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: computationCommandQueue.
	computationCommandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: computationCommandAllocator initial_pipeline_state: nil.
	computationCommandList close.
	isComputationCommandListOpen := false.
	hasPendingComputations := false.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> setupComputationCommandList [
	computationCommandAllocator reset.
	computationCommandList reset: computationCommandAllocator initial_pipeline_state: nil.
	isComputationCommandListOpen := true.
	computationCommandList
		setShaderSignature: computeShaderSignature.
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> shaderLibraryForSpirVModule: spirVModule [
	^ spirVModuleHandleMap at: spirVModule ifAbsentPut: [
		| shader code |
		shader := device createShader: AGPU_LIBRARY_SHADER.
		code := spirVModule bytes.
		shader
			setShaderSource: AGPU_SHADER_LANGUAGE_SPIR_V sourceText: code sourceTextLength: code size;
			compileShader: '';
			yourself.
	]
]

{ #category : #'as yet unclassified' }
SAbstractGPUExecutionDriver >> validStorageBufferHandleFor: managedDataArray [
	^ gpuBufferHandleMap at: managedDataArray ifAbsentPut: [ 
		| rawCpuData description newBuffer |
		rawCpuData := managedDataArray rawCpuData.
		description := AGPUBufferDescription new
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			stride: rawCpuData elementSize;
			size: rawCpuData rawDataSize;
			usage_modes: AGPU_COPY_SOURCE_BUFFER | AGPU_COPY_DESTINATION_BUFFER | AGPU_STORAGE_BUFFER;
			main_usage_mode: AGPU_STORAGE_BUFFER;
			mapping_flags: AGPU_MAP_DYNAMIC_STORAGE_BIT;
			yourself.
		newBuffer := device createBuffer: description initial_data: nil.
		self assert: newBuffer isNotNil.
		self assert: newBuffer isNull not.
		managedDataArray gpuBufferHandle: newBuffer.
		newBuffer
	].
	
]
